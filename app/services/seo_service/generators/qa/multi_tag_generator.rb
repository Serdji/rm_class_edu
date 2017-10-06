class SeoService
  module Generators
    module Qa
      class MultiTagGenerator < BaseGenerator
        TAG_CHARACTERS = %w(авторы классы предметы).freeze

        def title
          "#{tags.map(&:name).join(',')} – Рамблер/класс"
        end

        def description
          if special?
            "Сборник готовых домашних заданий по предмету #{subject_tag.name} " \
            "за #{class_tag.name}. Авторы #{author_tags.map(&:name).join(', ')}. " \
            'Номера задач и правильные ответы'
          else
            "Ответы на вопросы по темам #{tags.map(&:name).join(', ')} – читайте на Рамблер/класс"
          end
        end

        def keywords
          "#{tags.map(&:name).join(', ')}, решебник, ответы"
        end

        def tags
          @seo_tags ||= o.tags!(sort: 'placement_index')
        end

        def special?
          arr = tag_characters.values & TAG_CHARACTERS
          arr.size == TAG_CHARACTERS.size
        end

        def tag_characters
          @tag_characters ||= o.tags.select { |t| t.tag_character.present? }
                               .map { |t| [t.id, t.tag_character.title] }.to_h
        end

        def subject_tag
          tags.to_a.find { |t| t.id == subject_tag_id }
        end

        def class_tag
          tags.to_a.find { |t| t.id == class_tag_id }
        end

        def author_tags
          tags.to_a.select { |t| author_tag_ids.include? t.id }
        end

        def subject_tag_id
          tag_characters.find { |_k, v| 'предметы' == v }.first
        end

        def class_tag_id
          tag_characters.find { |_k, v| 'классы' == v }.first
        end

        def author_tag_ids
          tag_characters.select { |_k, v| 'авторы' == v }.keys
        end
      end
    end
  end
end
