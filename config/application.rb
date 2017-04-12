require_relative 'boot'
require_relative '../lib/redis_factory'
require 'prometheus/client/rack/collector'
require 'prometheus/client/rack/exporter'

require 'rails/all'
require 'sprockets/es6'

Bundler.require(*Rails.groups)

module Education
  class Application < Rails::Application
    config.i18n.default_locale = :ru

    config.paths['lib/tasks'] << Rails.root.join('db/seeds')

    config.paths['config/routes.rb'] << 'config/routes/admin.rb'
    config.paths['config/routes.rb'] << 'config/routes/front.rb'
    config.paths['config/routes.rb'] << 'config/routes/monitor.rb'

    # In development - autoload, in production - eager load
    config.eager_load_paths << Rails.root.join('lib')

    config.time_zone = 'Moscow'

    config.tinymce.install = :copy

    config.active_job.queue_adapter = :resque

    config.action_view.sanitized_allowed_tags = %w(strong a b em i u sub sup img)
    config.action_view.sanitized_allowed_attributes = %w(src alt rel href height width)

    Rails.application.config.cache_store = :redis_store, RedisFactory.get_config_for(:cache)

    config.middleware.use Prometheus::Client::Rack::Exporter
    config.middleware.use Prometheus::Client::Rack::Collector

    sentry_url = ENV['SENTRY_URL']
    if sentry_url.present?
      require 'sentry-raven'

      Raven.configure do |config|
        config.dsn = sentry_url
      end
    end

    initializer 'load_activerecord_ext' do
      ActiveSupport.on_load(:active_record) do
        extend ActiveRecordExt::FirstRandom
      end
    end

    initializer 'load_actioncontroller_ext' do
      ActiveSupport.on_load(:action_controller) do
        include ActionControllerExt::Breadcrumbs
      end
    end

    initializer 'load_activejob_ext' do
      ActiveSupport.on_load(:active_job) do
        extend ActiveJobExt::Perform
      end
    end
  end
end
