class SeoService
  module Generators
    class AuthorGenerator < BaseGenerator
      def title
        "#{author_name(o)} – все учебники – Рамблер/класс"
      end

      delegate :description, to: :o

      def keywords
        name = author_name(o)
        subjects = o.subjects.map(&:name).join(', ') if o.subjects.exists?

        [name, subjects, 'учебники'].compact.shuffle.join(', ')
      end
    end
  end
end
