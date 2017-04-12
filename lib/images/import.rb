module Images::Import
  class << self
    def save(local, url)
      FileUtils.mkpath File.dirname(local)
      begin
        File.open(local, 'wb+') do |local_file|
          open(url, 'rb') { |remote| local_file.write(remote.read) }
        end
      rescue OpenURI::HTTPError => _ex
        true
      end
    end
  end
end
