require 'hashie'

class SearchService
  class Result
    attr_reader :result

    delegate :total_found, :questions_found, :tags_found, to: :@result

    def initialize(result, pagination = {})
      @size, @from = pagination.values_at(:size, :from)
      @result = Hashie::Mash.new(result)
    end

    def empty?
      total_found.zero?
    end

    def any?
      !empty?
    end

    def each
      @result.matches.each { |object| yield(object) }
    end

    def each_with_index
      @result.matches.each_with_index { |object, index| yield(object, index) }
    end

    def total_pages
      [(total_found / per_page.to_f).ceil, 1].max
    end

    def current_page
      (@from / per_page.to_f).ceil + 1
    end

    def per_page
      @size
    end

    def first_page?
      current_page == 1
    end

    def last_page?
      current_page == total_pages
    end

    def has_next_page?
      current_page < total_pages
    end

    def has_previous_page?
      current_page > 1
    end
  end
end
