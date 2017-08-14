require 'prometheus/client/rack/exporter'
require 'prometheus/client/rack/collector'

class Prometheus::ExceptionsCollector < Prometheus::Client::Rack::Collector
  def initialize(app, options = {}, &label_builder)
    @app = app
    @registry = options[:registry] || Prometheus::Client.registry
    @label_builder = label_builder || DEFAULT_LABEL_BUILDER

    init_exception_metrics
  end
end
