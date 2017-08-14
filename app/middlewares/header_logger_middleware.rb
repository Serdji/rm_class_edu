require 'rack'

class HeaderLoggerMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)

    request.env.each do |key, value|
      Rails.logger.debug("#{key} ==> #{value}") if key.start_with?('HTTP_')
    end

    @app.call(env)
  end
end
