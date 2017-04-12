namespace :db do
  desc 'Move database: cap preprod db:sync[staging2] or cap preprod db:sync[develop]'
  task :sync, [:stage] do |_t, args|
    # Check import route, allow only:
    # preprod => staging, staging2, develop
    # staging => staging2, develop
    # staging2 => staging, develop
    args.with_defaults(stage: 'staging2')
    from = fetch(:stage).to_s
    to = args.stage.to_s
    unless %w(staging staging2 develop).include? to
      puts "\e[0;31mCan synchronize database to staging/staging2 only\e[0;32m"
      next
    end
    if from == to
      puts "\e[0;31mCan\'t synchronize the same database\e[0;32m"
      next
    end
    # Download dump
    tmp = 'tmp/education.sql'
    on roles :backend do
      old_verbosity = SSHKit.config.output_verbosity
      SSHKit.config.output_verbosity = Logger::FATAL

      env = Dotenv::Parser.call(capture("cat #{current_path}/.env.local"))

      dump = "export PGPASSWORD=#{env['DATABASE_PASSWORD']}; " \
             "pg_dump -c -h #{env['DATABASE_HOSTNAME']} " \
                     "-p #{env['DATABASE_PORT']} " \
                     "-U #{env['DATABASE_USERNAME']} " \
                     "-d #{env['DATABASE_NAME']} > #{tmp} "
      system(dump)

      SSHKit.config.output_verbosity = old_verbosity
    end
    if to == 'develop'
      # Execute dump
      database_config = YAML.load(ERB.new(File.read('config/database.yml')).result)
      database = database_config['development']['database']
      `psql -d #{database} < #{tmp}`
      `rake employees:passwords:update`
      `rake images:import[#{from}]`
    elsif %w(staging staging2).include? to
      # Upload dump
      to_host = if to == 'staging'
                  'class@back01.stage.class.rambler.ru'
                else
                  'class@back02.stage.class.rambler.ru'
                end
      on [to_host], in: :sequence, wait: 5 do |_host|
        with rails_env: to do
          within current_path do
            env = Dotenv::Parser.call(capture("cat #{current_path}/.env.local"))
            dump = "export PGPASSWORD=#{env['DATABASE_PASSWORD']}; " \
                   "psql -d #{env['DATABASE_NAME']} -h #{env['DATABASE_HOSTNAME']} " \
                        "-p #{env['DATABASE_PORT']} -U #{env['DATABASE_USERNAME']} < #{tmp} "
            system(dump)

            # execute :rake, 'employees:passwords:update'
            execute 'cd /var/www/class.rambler.ru/current && ' \
                    "( export RAILS_ENV=#{to}; " \
                    '~/.rvm/bin/rvm 2.3.1 do bundle exec rake employees:passwords:update )'
            # execute :rake, 'webdav:import[#{from},#{to}]'
            execute 'cd /var/www/class.rambler.ru/current && ' \
                    "( export RAILS_ENV=#{to}; " \
                    "~/.rvm/bin/rvm 2.3.1 do bundle exec rake images:webdav:import[#{from},#{to}] )"
          end
        end
      end
    end
    `rm -rf #{tmp}`
  end
end
