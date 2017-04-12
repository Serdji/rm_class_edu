class SeoService
  module Generators
    module Qa
      class QuestionGenerator < BaseGenerator
        def title
          "#{gsubbed_title} – Рамблер/класс"
        end

        def description
          "Ответы на вопрос – #{gsubbed_title} – читайте на Рамблер/класс"
        end

        def keywords
          [o.tags.first.try(:name), 'ответ', 'вопрос', 'задание', 'школа'].compact.join(', ')
        end

        private

        def gsubbed_title
          o.title.tr("\n", ' ')
        end
      end
    end
  end
end
