class SeoService
  module Generators
    class BookGenerator < BaseGenerator
      def title
        "#{o.name} – Рамблер/класс"
      end

      delegate :description, to: :o

      # rubocop:disable Metrics/AbcSize
      def keywords
        author_name = author_name(o.authors.first)
        subject_name = o.subject.name

        grades = "#{o.grades.map(&:grade).join(', ')} класс" if o.grades.exists?
        [author_name, subject_name, grades].compact.shuffle.join(', ')
      end
    end
  end
end
