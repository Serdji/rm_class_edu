class AssetHostFactory
  class << self
    delegate :domain, to: :new
  end

  def initialize
    @yaml = Rails.application.config_for('asset_host')
    @yaml.deep_symbolize_keys!
  end

  def domain
    @yaml.fetch(:domain)
  end
end
