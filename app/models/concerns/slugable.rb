module Slugable
  extend ActiveSupport::Concern

  included do
    validates :slug, uniqueness: true
  end

  def set_slug
    self.slug = parameterized_slug
  end

  def set_slug!
    update_attribute(:slug, parameterized_slug)
  end

  private

  def parameterized_slug
    value = slug.present? ? slug : slug_param
    TranslitService.translit(value).tr('_', ' ').parameterize
  end
end
