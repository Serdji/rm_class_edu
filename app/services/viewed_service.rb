class ViewedService
  def initialize(request, strategy = fetch_strategy)
    @strategy = strategy.new(request, key, limit)
  end

  def remove(id)
    @strategy.remove(id.to_i)
  end

  def add(id)
    @strategy.add(id.to_i)
  end

  def collection_ids
    @strategy.collection_ids
  end

  def collections
    raise 'You must overload collections method'
  end

  def key
    raise 'You must overload key method to set name of redis/cookie parameter'
  end

  def limit
    12
  end

  private

  def fetch_strategy
    Rails.env.development? ? SessionStrategy : RedisStrategy
  end
end
