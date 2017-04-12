class SeoService
  module Generators
    module Qa
      class TagGenerator < BaseGenerator
        def title
          "#{o.name}: вопросы и ответы – Рамблер/класс"
        end

        def description
          "Ответы на вопросы по теме #{o.name} – читайте на Рамблер/класс"
        end

        def keywords
          "#{o.name}, вопрос, ответ, школа"
        end
      end
    end
  end
end
