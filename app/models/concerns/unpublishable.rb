module Unpublishable
  extend ActiveSupport::Concern

  included do
    alias_attribute :published?, :is_published
    after_save :update_textbooks_state, if: -> { is_published_changed? }
  end

  private

  def update_textbooks_state
    return if published?
    published = %w(published published_not_good part_published)
    values = Textbook.states.select { |k, _| published.include?(k) }.values
    textbooks.where(state: values).update_all(state: Textbook.states['unpublished'])
  end
end
