class DomainFactory
  def self.url(stage = Rails.env)
    return 'http://localhost:3000' if %w(development test).include?(stage)

    subdomains = YAML.load_file(Rails.root.join('config', 'subdomains.yml'))
    subdomain = subdomains.dig(stage, 'front')

    "https://#{subdomain}.rambler.ru"
  end
end
