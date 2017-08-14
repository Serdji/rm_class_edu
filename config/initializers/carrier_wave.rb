CarrierWave.configure do |config|
  namespace = "qa-service/#{Rails.env}"

  webdav_config = WebdavFactory.new
  asset_host_config = AssetHostFactory.new

  if Rails.env.test? || Rails.env.development?
    config.storage = :file
    config.asset_host = 'http://localhost:3000'
  else
    config.storage = :webdav
    config.cache_storage = :webdav

    config.webdav_server = [webdav_config.url, namespace].join('/')
    config.webdav_host_header = webdav_config.header
    config.asset_host = [asset_host_config.domain, namespace].join('/')
  end
end

CarrierWave::SanitizedFile.sanitize_regexp = /[^[:word:]\.\-\+]/
