module Cachable
  extend ActiveSupport::Concern

  included do
    after_commit :rebuild_cache

    def cachable_cache_key(field)
      self.class.cache_key(id, field)
    end

    private

    def rebuild_cache
      MarkdownJob.perform(self.class.name, id)
    end
  end

  module ClassMethods
    def cachable(*columns)
      unless const_defined?(:MARKDOWN_FIELDS)
        const_set(:MARKDOWN_FIELDS, columns)
      end

      columns.each do |column|
        define_method "#{column}_html" do
          key = respond_to?(:cachable_cache_key) ? cachable_cache_key(column) : column
          Rails.cache.read(key)
        end
      end
    end

    def cache_key(id, field)
      "#{model_name.collection}:#{id}:#{field}"
    end
  end
end
