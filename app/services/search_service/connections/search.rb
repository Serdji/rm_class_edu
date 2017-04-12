class SearchService
  module Connections
    class Search
      ENDPOINT = URI(
        'http://api.rambler.ru/search/class/search'
      )

      class JsonResponseMiddleware < Faraday::Response::Middleware
        def on_complete(response_env)
          response = JSON.parse(response_env[:body])
        rescue
          response = empty_response
        ensure
          response_env[:body] = response
        end

        private

        def empty_response
          { matches: [], total_found: 0, tags_found: 0, questions_found: 0 }
        end
      end

      def initialize
        @connection = Faraday.new do |builder|
          builder.use Faraday::Request::UrlEncoded
          builder.use JsonResponseMiddleware
          builder.adapter Faraday.default_adapter
        end
      end

      def call(query, options = {})
        params = { query: query }
        params.merge!(options)

        @connection.get(ENDPOINT, params)
      end
    end
  end
end
