class RedisFactory
  VALID_TYPES = %w(cache queue).freeze

  class << self
    def build_connection_for(type)
      check_type(type)
      Redis.new get_config_for(type)
    end

    def get_config_for(type)
      check_type(type)

      config = File.read(Rails.root.join("config/redis/#{type}.yml"))
      config = YAML.load(ERB.new(config).result)

      duped = config[Rails.env].dup
      duped.deep_symbolize_keys!
    end

    private

    def check_type(type)
      raise "Invalid redis config type: #{type}" unless valid_type?(type)
    end

    def valid_type?(type)
      VALID_TYPES.include?(type.to_s)
    end
  end
end
