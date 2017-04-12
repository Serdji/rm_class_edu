class SeoService
  module Generators
    class BaseGenerator
      attr_reader :object

      alias o object

      def initialize(object)
        @object = object
      end

      def author_name(author)
        "#{author.last_name} #{author.first_name.first}. #{author.patronymic.first}."
      end
    end
  end
end
