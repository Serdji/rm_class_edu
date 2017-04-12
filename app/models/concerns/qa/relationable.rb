module Qa::Relationable
  extend ActiveSupport::Concern

  class_methods do
    delegate :limit, to: :scoped
    delegate :order, to: :scoped
  end
end
