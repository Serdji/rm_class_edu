Resque.redis = RedisFactory.build_connection_for(:queue)

Resque.after_fork do
  ActiveRecord::Base.establish_connection
  Resque.redis.disconnect!
end
