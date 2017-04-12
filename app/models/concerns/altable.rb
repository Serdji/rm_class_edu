module Altable
  extend ActiveSupport::Concern

  included do
    before_save :fill_alt_text
  end

  def fill_alt_text
    return if alt_text.present?
    self.alt_text = imageable&.name
  end
end
