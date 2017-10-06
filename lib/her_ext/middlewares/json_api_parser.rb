module HerExt
  module Middlewares
    class JsonApiParser < ::Her::Middleware::ParseJSON
      def parse(body)
        json = parse_json(body)

        {
          data: json.fetch(:data, {}),
          errors: json.fetch(:errors, []),
          metadata: json.fetch(:meta, {})
        }
      end

      def on_complete(env)
        env[:body] = case env[:status]
                       when 500 then print_error(env) && bare_response
                       when 204 then bare_response
                       else parse(env[:body])
                     end
      end

      private

      def print_error(env)
        response = parse_json(env[:body])
        error, exception = response.values_at(:error, :exception)
        Rails.logger.info("#{error}: #{exception}")
      end

      def bare_response
        {
          data: {},
          errors: [],
          metadata: {}
        }
      end
    end
  end
end
