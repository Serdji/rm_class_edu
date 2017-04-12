class ViewedService
  class SessionStrategy
    attr_reader :key_base, :collection_limit

    def initialize(request, key_base = 'key', collection_limit = 12)
      @request = request
      @key_base         = key_base
      @collection_limit = collection_limit
    end

    def remove(id)
      viewed_collections.delete(id.to_i)
    end

    def add(id)
      return if viewed_collections.include?(id)
      viewed_collections.pop if viewed_collections.count == collection_limit
      viewed_collections.unshift(id)
    end

    def collection_ids
      viewed_collections
    end

    private

    def viewed_collections
      @request.session[key_base] ||= []
    end
  end
end
