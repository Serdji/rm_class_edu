class SeoService
  module Generators
    class MetapageGenerator
      delegate :title, :description, :keywords, to: :@generator

      def initialize(metapage)
        @metapage = metapage
        @generator = resolve_object
      end

      private

      def resolve_object
        EmptyGenerator.new
      end
    end
  end
end
