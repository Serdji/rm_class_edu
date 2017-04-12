CarrierWave.configure do |config|
  if Settings.webdav
    config.storage = :webdav
    config.webdav_server = WebdavFactory.url(Rails.env)
    config.webdav_host_header = WebdavFactory.host(Rails.env)
  end

  asset_host = case Rails.env
    when 'production' then 'https://class.rambler.ru'
    when 'preprod'    then 'https://preprod.class.rambler.ru'
    when 'staging'    then 'https://staging.class.rambler.ru'
    when 'staging2'   then 'https://staging2.class.rambler.ru'
    when 'test'       then 'https://host.com'
    else ''
  end

  config.asset_host = asset_host
end

CarrierWave::SanitizedFile.sanitize_regexp = /[^[:word:]\.\-\+]/
