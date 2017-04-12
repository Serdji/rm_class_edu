module Images::Import::Local
  class << self
    def download(klass, url)
      progressbar = ProgressBar.create(title: klass.name, total: klass.count)
      klass.find_each do |item|
        if item.image.path.present?
          local_item(item, url) do
            progressbar.increment
            item.image.recreate_versions!
          end
        end
      end
      progressbar.finish
    end

    def local_item(item, url)
      Images::Import.save(item.image.path, "#{url}#{item.image.url}")
      yield if block_given?
    end
  end
end
