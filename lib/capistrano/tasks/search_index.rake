namespace :search do
  namespace :index do
    desc 'Reindex questions'
    task :questions do
      on roles([:reindex]) do
        within release_path do
          rake 'search:index:questions'
        end
      end
    end

    desc 'Reindex tags'
    task :tags do
      on roles([:reindex]) do
        within release_path do
          rake 'search:index:tags'
        end
      end
    end

    desc 'Reindex questions and tags'
    task :all do
      on roles([:reindex]) do
        within release_path do
          rake 'search:index:all'
        end
      end
    end
  end
end
