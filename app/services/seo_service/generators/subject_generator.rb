class SeoService
  module Generators
    class SubjectGenerator < BaseGenerator
      def title
        "Все учебники по #{o.name} – Рамблер/класс"
      end

      # TODO: remove delegation to metapage
      def description
        metapage = ::Metapage.find_by(grade_id: nil, subject_id: o.id)
        metapage.description
      end

      def keywords
        subject_name = o.name

        grades = o.grades.map(&:grade).join(', ') + ' класс' if o.grades.exists?

        [subject_name, grades, 'учебники'].compact.shuffle.join(', ')
      end
    end
  end
end
