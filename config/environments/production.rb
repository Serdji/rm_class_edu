require_relative 'staging'

Rails.application.configure do
  config.action_mailer.default_url_options = { host: 'class.rambler.ru' }
end
