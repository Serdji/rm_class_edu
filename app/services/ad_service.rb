class AdService
  def initialize
    @ads = Hash.new(1).with_indifferent_access
    @lock = Mutex.new
  end

  def id_for(name)
    synchronize do
      old_value = @ads[name]
      @ads[name] += 1

      old_value
    end
  end

  private

  def synchronize
    @lock.synchronize { yield }
  end
end
