class WebdavFactory
  class << self
    delegate :url, :header, to: :new
  end

  def initialize
    @yaml = Rails.application.config_for('webdav')
    @yaml.deep_symbolize_keys!
  end

  def path
    @yaml.fetch(:path)
  end

  def header
    @yaml.fetch(:header)
  end

  def domain
    @yaml.fetch(:domain)
  end

  def url
    [domain, path].join('/')
  end
end
