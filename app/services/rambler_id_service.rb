require 'rambler_id'

class RamblerIdService
  AVATAR_PREFIX = 'https://avatars.rambler.ru/get'.freeze
  AVATAR_REPLACEMENT = 'https://avatars.rambler.ru/200x200'.freeze

  attr_reader :rsid

  def initialize(rsid)
    @rsid = rsid
    @response = RamblerID.get_profile_info(rsid: @rsid, get_chain_id: 1)
  end

  def authenticated?
    @response.ok?
  end

  def chain_id
    @response.body.dig(:profile, :info, :chain_id, :all) if authenticated?
  end

  def default_id
    @response.body.dig(:profile, :info, :chain_id, :default) if authenticated?
  end

  def profile_info
    if authenticated?
      info = @response.body.dig(:profile, :profile)
      prepare_info!(info)

      avatar = @response.body.dig(:profile, :display, :avatar, :url)
      info.merge!(avatar_url: normalize_avatar_url(avatar))
    end
  end

  def internal_user
    @internal_user ||= (find_user || create_user) if authenticated?
  end

  def rambler_user
    profile_info
  end

  private

  def find_user
    user = Qa::User.where(filter: { external_id: chain_id }).first
    synchronize_user_info!(user) if user
    user
  end

  def create_user
    Qa::User.create(build_attributes)
  end

  def build_attributes
    {
      external_id: default_id, external_id_type: 'rsid'
    }.merge! profile_info.slice(:first_name, :last_name, :gender, :avatar_url)
  end

  def prepare_info!(info)
    info.first_name = info.delete(:firstname)
    info.last_name = info.delete(:lastname)
    info.gender = normalize_gender(info.delete(:gender))
  end

  def normalize_gender(value)
    { 'm' => 'male', 'f' => 'female' }[value]
  end

  def synchronize_user_info!(user)
    synced = true

    profile_info.each do |key, value|
      if user.respond_to?(key) && user[key] != value
        user.send("#{key}=", value)
        synced = false
      end
    end

    user.save unless synced
  end

  def normalize_avatar_url(avatar)
    avatar.to_s.gsub(AVATAR_PREFIX, AVATAR_REPLACEMENT)
  end
end
