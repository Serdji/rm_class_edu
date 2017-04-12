class SearchService
  module Connections
    class Index
      ENDPOINT = URI(
        'http://api.rambler.ru/search/class/push'
      )

      class JsonRequestMiddleware < Faraday::Middleware
        def call(request_env)
          request_env[:request_headers]['Content-Type'] = 'application/json'
          request_env[:body] = JSON.dump(request_env[:body])

          @app.call request_env
        end
      end

      class JsonResponseMiddleware < Faraday::Response::Middleware
        def on_complete(response_env)
          response = JSON.parse(response_env[:body])
        rescue
          response = response_env[:body]
        ensure
          response_env[:body] = response
        end
      end

      def initialize
        @connection = Faraday.new do |builder|
          builder.use JsonRequestMiddleware
          builder.use JsonResponseMiddleware
          builder.adapter Faraday.default_adapter
        end
      end

      def call(data)
        @connection.post(ENDPOINT, data)
      end
    end
  end
end
