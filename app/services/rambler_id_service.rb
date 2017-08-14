class RamblerIdService
  attr_reader :rsid

  def initialize(rsid)
    @rsid = rsid
  end

  def profile
    @profile ||= RamblerID::Utility.get_full_profile(@rsid)
  end

  def profile_hash
    @profile_hash ||= begin
      return unless profile
      data = profile.to_h
      data[:emails] = data[:confirmed_emails]
      data.except(:confirmed_emails, :unconfirmed_emails)
    end
  end

  def authenticated?
    profile.present?
  end

  def find_user_by_chain_ids
    Qa::User.find_by_chain_ids(profile.chain_ids)
  end

  def create_user
    Qa::User.create_from_rid_profile(self)
  end
end
