namespace :deploy do
  namespace :npm do
    task :install do
      on roles fetch(:npm_roles) do
        within fetch(:npm_target_path, release_path) do
          with fetch(:npm_env_variables, {}) do
            unless ENV['ASSETS'] == 'false'
              execute :npm, 'install', fetch(:npm_flags)
              execute :npm, 'run clean &> /dev/null'
              execute :npm, 'run build &> /dev/null'
            end
          end
        end
      end
    end
  end
end
