require 'resque/tasks'

task 'resque:setup' => :environment

require_relative 'config/application'

Rails.application.load_tasks

seed_tasks = Rake.application.tasks.select { |task| task.name =~ /db:seed:/ }
seed_tasks.unshift :environment if Rake::Task.task_defined?(:environment)

# Run all db:seed:* tasks before db:seed
Rake::Task['db:seed'].enhance seed_tasks

namespace :resque do
  task :setup do
    Resque.before_fork = proc do
      ActiveRecord::Base.connection.disconnect!
    end

    Resque.after_fork = proc do
      ActiveRecord::Base.establish_connection
    end
  end
end

if Rails.env.test?
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:rspec)

  RSpec::Core::RakeTask.new(:rspec_integration) do |t|
    t.rspec_opts = '--tag integration'
  end

  RSpec::Core::RakeTask.new(:rspec_unit) do |t|
    t.rspec_opts = '--tag ~integration'
  end

  task :docker_tests do
    sh 'docker-compose -f docker-compose-test.yml run education'
    sh 'docker-compose -f docker-compose-test.yml down'
  end
end
