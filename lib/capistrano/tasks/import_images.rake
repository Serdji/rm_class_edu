task :import_images do
  on roles(:db) do
    within release_path do
      with filepath: ENV['FILEPATH'] do
        abort 'Environment FILEPATH is not set' unless ENV['FILEPATH']

        upload! 'images.csv', ENV['FILEPATH']
        rake :import_images
      end
    end
  end
end
