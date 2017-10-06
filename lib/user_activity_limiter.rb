class UserActivityLimiter
  NAMESPACE = 'user_activity_limiter'.freeze
  THRESHOLD = 5
  TTL = 1.minute

  attr_reader :threshold, :ttl, :user_id

  def initialize(user_id, threshold: nil, ttl: nil)
    @threshold = threshold || THRESHOLD
    @ttl = ttl || TTL
    @user_id = user_id
  end

  def exceeded?
    count >= threshold
  end

  def store
    clean
    member_score = now
    redis.zadd(build_key, member_score, member_score)
  end

  def clear
    redis.del(build_key)
  end

  def user_blocked?
    redis.exists(build_block_key)
  end

  def block_user
    redis.set(build_block_key, true)
  end

  def unblock_user
    redis.del(build_key)
    redis.del(build_block_key)
  end

  private

  def clean
    redis.zremrangebyscore(build_key, 0, now(ttl))
  end

  def count
    redis.zcount(build_key, now(ttl), now)
  end

  def build_key
    [NAMESPACE, user_id].join(':')
  end

  def build_block_key
    [NAMESPACE, :blocked_users, user_id].join(':')
  end

  def now(offset = nil)
    now = Time.zone.now
    (offset ? now - offset : now).to_datetime.strftime('%Q')
  end

  def redis
    @redis ||= Redis.current
  end
end
