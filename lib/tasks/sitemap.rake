namespace :sitemap do
  desc 'Upload local sitemap to WebDav'
  task upload: :environment do
    local_path = Rails.root.join('public/sitemap.xml.gz').to_s
    if File.exist? local_path
      url = WebdavFactory.url
      host = WebdavFactory.header
      `curl -H 'Host: #{host}' -T '#{local_path}' '#{url}/sitemap.xml.gz'`
    end
  end
end
