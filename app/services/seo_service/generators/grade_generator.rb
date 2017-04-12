class SeoService
  module Generators
    class GradeGenerator < BaseGenerator
      def title
        "Все учебники для #{o.grade} класса – Рамблер/класс"
      end

      # TODO: remove delegation to metapage
      def description
        metapage = ::Metapage.find_by!(grade_id: o.id, subject_id: nil)
        metapage.description
      end

      def keywords
        grade_name = "#{o.grade} класс"

        subjects = o.subjects.limit(5).map(&:name).join(', ') if o.subjects.exists?

        [grade_name, subjects, 'учебники'].compact.shuffle.join(', ')
      end
    end
  end
end
