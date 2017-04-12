# rubocop:disable all
module HerExt
  module Middlewares
    class JsonApiParser < ::Her::Middleware::ParseJSON
      def parse(body)
        json = parse_json(body)

        included = json.fetch(:included, [])
        primary_data = json.fetch(:data, {})

        unless json[:errors]
          Array.wrap(primary_data).each do |resource|
            resource_relationships = resource.delete(:relationships) { {} }
            resource[:attributes].merge!(populate_relationships(resource_relationships, included.dup))
          end
        end

        {
          data: primary_data || {},
          errors: json[:errors] || [],
          metadata: json[:meta] || {}
        }
      end

      def populate_relationships(relationships, included)
        return {} if included.empty?
        {}.tap do |built|
          relationships.each do |rel_name, linkage|
            linkage_data = linkage.fetch(:data, {})
            built_relationship = if linkage_data.is_a? Array
                                   linkage_data.map { |l| included.detect { |i| i.values_at(:id, :type) == l.values_at(:id, :type) } }.compact
                                 elsif linkage_data.present?
                                   included.detect { |i| i.values_at(:id, :type) == linkage_data.values_at(:id, :type) }
            end

            built[rel_name] = built_relationship
          end
        end
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
