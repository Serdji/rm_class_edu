class ViewedService
  class RedisStrategy
    EXPIRE = 30.days
    attr_reader :key_base, :collection_limit

    def initialize(request, key_base = 'key', collection_limit = 12)
      @request          = request
      @key_base         = key_base
      @collection_limit = collection_limit
    end

    def remove(id)
      redis.del(build_key(id))
    end

    # rubocop:disable Metrics/AbcSize
    def add(id)
      key = build_key(id)

      unless redis.exists(key)
        remove(last_id) if keys.count == collection_limit
        redis.set(key, "#{Time.now.to_f}:#{id}")
      end

      redis.expire(key, EXPIRE.to_i)
    end

    def collection_ids
      return [] unless values.present?
      hash = values.map { |key| key.split(':') }
      hash.sort_by(&:first).map(&:last).map(&:to_i).reverse
    end

    private

    def keys
      redis.keys(build_key('*'))
    end

    def values
      return [] unless keys.any?
      redis.mget(keys)
    end

    def last_id
      time_ids = values.map { |value| value.split(':') }
      _, id = time_ids.min_by { |time, _id| time }
      id
    end

    def build_key(id)
      "#{key_base}:#{cookie_key}:#{id}"
    end

    def redis
      Redis.current
    end

    def cookie_key
      if (value = @request.cookie_jar[key_base]).present?
        value
      else
        SecureRandom.hex.tap do |hex|
          @request.cookie_jar[key_base] = {
            value: hex,
            expires: 10.years.from_now,
            httponly: true
          }
        end
      end
    end
  end
end
