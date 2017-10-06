class TagPagesService
  class Spliter
    include Enumerable

    def initialize(tags)
      @tags = tags
      @total_tags = tags.size
    end

    # [5, 4, 4, 9, 4, 4, 9, 4, 4, 9, ...]
    def each
      i = 0
      summ = 0
      interval = 0
      loop do
        interval = if (i % 3).zero?
                     i.zero? ? 6 : 9
                   else
                     4
                   end
        yield (i.zero? ? 0 : summ - 1), (summ += interval) - 1
        i += 1
        break if summ > @total_tags
      end
    end
  end
end
