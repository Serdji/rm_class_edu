module ActiveRecordExt
  module FirstRandom
    def first_random
      order('random()').first
    end
  end
end
