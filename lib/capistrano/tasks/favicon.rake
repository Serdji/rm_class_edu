namespace :deploy do
  task :favicon do
    on roles(:front), in: :sequence, wait: 5 do
      within Pathname.new(release_path).join('app/assets/images/icons').to_s do
        curl_host = '-H "Host: webdav.park.rambler.ru"'
        endpoint = File.join(fetch(:webdav_endpoint), fetch(:webdav_favicon), '/')
        %w(front staging staging2).each do |dir|
          execute :find, "#{dir} -type f -exec curl -T {} '#{endpoint}'{} #{curl_host} \\;"
        end
      end
    end
  end

  after :normalize_assets, :favicon
end
