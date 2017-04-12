class WebdavFactory
  class << self
    def yaml(stage = nil)
      @webdav ||= YAML.load_file(Rails.root.join('config', 'webdav.yml'))
      stage.present? ? @webdav[stage] : @webdav
    end

    def path(stage)
      yaml(stage)['path']
    end

    def host(stage)
      yaml(stage)['host']
    end

    def domain(stage)
      yaml(stage)['domain']
    end

    def url(stage)
      [domain(stage), path(stage)].join('/')
    end
  end
end
