module Avatarable
  extend ActiveSupport::Concern

  included do
    decorates_association :user, with: Front::UserDecorator
    delegate :avatar_style, to: :user, prefix: true, allow_nil: true
  end
end
