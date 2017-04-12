class SeoService
  module Generators
    class GradeSubjectGenerator < BaseGenerator
      def title
        "#{o.subject.name} #{o.grade.name} – все учебники – Рамблер/класс"
      end

      # TODO: remove delegation to metapage
      delegate :description, to: :o

      def keywords
        subject_name = o.subject.name
        grade_name = o.grade.name

        [subject_name, grade_name, 'учебники'].shuffle.join(', ')
      end
    end
  end
end
