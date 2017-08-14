class Seo < ActiveRecord::Base
  TITLE_MAX_LENGTH = 250
  DESCRIPTION_MAX_LENGTH = 200

  include Loggable

  belongs_to :seoable, polymorphic: true

  before_save :cut_fields
  before_save :fill_fields, unless: -> { filled? }

  loggable :all

  def filled?
    title.presence && keywords.presence && description.presence
  end

  def seoable
    if seoable_type.start_with?('Qa')
      seoable_type.constantize.find(seoable_id)
    else
      super
    end
  end

  private

  def cut_fields
    if title && title.size > TITLE_MAX_LENGTH
      self.title = cut_column(title, TITLE_MAX_LENGTH)
    end

    if description && description.size > DESCRIPTION_MAX_LENGTH
      self.description = cut_column(description, DESCRIPTION_MAX_LENGTH)
    end
  end

  def cut_column(string, length)
    result = string[/.*(?=\s)/]
    if result
      loop do
        # for too long none-whitespace words
        return result if result&.length.to_i <= length
        result = result[/.*(?=\s)/]
      end
    else
      string[0, length]
    end
  end

  def fill_fields
    return unless seoable # TODO: FIX THIS!!!

    seo_attributes = SeoService.new(seoable).seo_attributes

    self.title = seo_attributes[:title] unless title.present?
    self.keywords = seo_attributes[:keywords] unless keywords.present?
    self.description = seo_attributes[:description] unless description.present?
  end
end
