module Weightable
  extend ActiveSupport::Concern

  included do
    validates :weight, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 1000 }
    scope :order_by_weight, -> { order('weight desc') }
  end

  def weight=(value)
    default_value = self.class.column_defaults['weight']
    self[:weight] = value.present? ? value : default_value
  end
end
