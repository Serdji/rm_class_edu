module Seoable
  extend ActiveSupport::Concern

  included do
    after_save { create_seo unless seo }

    delegate :title, :keywords, :description, to: :seo, prefix: true, allow_nil: true
  end
end
