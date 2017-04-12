module ActiveJobExt
  module Perform
    def perform(*args)
      if Settings.async
        perform_later(*args)
      else
        perform_now(*args)
      end
    end
  end
end
