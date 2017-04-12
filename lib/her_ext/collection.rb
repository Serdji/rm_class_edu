module HerExt
  module Collection
    def current_page
      metadata[:current_page]
    end

    def per_page
      metadata[:per_page]
    end

    def offset
      (current_page - 1) * per_page
    end

    def total_entries
      metadata[:total_entries]
    end

    def total_pages
      metadata[:total_pages]
    end
  end
end
