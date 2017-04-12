module Images::Import::Remote
  class << self
    def move(klass, from, to)
      progressbar = ProgressBar.create(title: klass.name, total: klass.count)
      klass.find_each do |item|
        if item.image.path.present?
          remote_item(item, WebdavFactory.url(to), from) do
            progressbar.increment
            item.image.recreate_versions!
          end
        end
      end
      progressbar.finish
    end

    def remote_item(item, webdav_url, from)
      local_path = Rails.root.join("public/#{item.image.path}").to_s
      Images::Import.save(local_path, "#{DomainFactory.url(from)}/#{item.image.path}")
      curl(local_path, "#{webdav_url}/#{item.image.path}")
      yield if block_given?
    end

    def curl(local, remote)
      host = "-H 'Host: #{WebdavFactory.host('production')}'"
      `curl #{host} -T '#{local}' '#{remote}' 1>/dev/null`
    end
  end
end
