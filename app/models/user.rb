class User < ActiveRecord::Base
  def make_sentry
    self.is_sentry = true
    save!
  end

  def unmake_sentry
    self.is_sentry = false
    save!
  end
end
