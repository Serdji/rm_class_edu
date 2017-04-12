namespace :deploy do
  task :load_eye do
    on roles([:front, :backend]) do
      within release_path do
        execute :eye, 'load config/eye.rb'
      end
    end

    on roles([:queue]) do
      within release_path do
        execute :eye, 'load config/eye.rb'
      end
    end
  end

  task :restart do
    on roles([:front, :backend]), in: :sequence, wait: 5 do
      within release_path do
        execute :eye, 'restart class.rambler.ru:web'
      end
    end

    on roles([:queue]), in: :sequence, wait: 5 do
      within release_path do
        execute :eye, 'restart class.rambler.ru:resque'
      end
    end
  end

  task :stop do
    on roles([:front, :backend]), in: :sequence, wait: 5 do
      within release_path do
        execute :eye, 'stop class.rambler.ru:web'
      end
    end

    on roles([:queue]), in: :sequence, wait: 5 do
      within release_path do
        execute :eye, 'stop class.rambler.ru:resque'
      end
    end
  end

  before :restart, :load_eye

  after :publishing, :restart
  after :compile_assets, 'npm:install'
end
