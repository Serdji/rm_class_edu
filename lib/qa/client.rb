class Qa::Client
  include Singleton

  class Collection
    include Enumerable

    delegate :total_pages, :total_entries, :per_page, :current_page, to: :@meta

    def initialize(response, klass)
      @klass = klass.to_s.demodulize
      @collection = response.body['data'].map { |attrs| klass.new(attrs) }
      @meta = OpenStruct.new(response.body['meta'])
    end

    def each
      @collection.each { |object| yield object }
    end

    def includes(*models)
      models.each { |model| includes!(model) }
      self
    end

    def includes!(model)
      includes = linked(model)
      @collection.each do |item|
        item.send("#{model}=", includes.key?(item.id) ? includes[item.id] : inclass(model).new)
      end
    end

    def inclass(model)
      if model == :image && @klass == 'Tag'
        Images::Tag
      else
        model.to_s.camelize.safe_constantize
      end
    end

    def linked(model)
      able = polymorphous(model)
      inclass(model).where(
        "#{able}_type" => "Qa::#{@klass}",
        "#{able}_id" => @collection.map(&:id)
      ).map { |x| [x.send("#{able}_id"), x] }.to_h
    end

    def polymorphous(model)
      "#{model}able"
    end
  end

  class << self
    delegate :call, to: :instance
  end

  # TODO: refactor
  def initialize
    qa_config = Rails.application.config_for(:qa_api)

    faraday_options = {
      url: qa_config.fetch('domain'),
      headers: {
        'X-Api-Version' => qa_config.fetch('api_version'),
        'X-Api-Token' => qa_config.fetch('api_token')
      }
    }

    @connection = Faraday.new(faraday_options) do |builder|
      # Request
      builder.use Her::Middleware::AcceptJSON

      # Response
      builder.use FaradayMiddleware::ParseJson

      # Adapter
      builder.adapter Faraday.default_adapter
    end
  end

  def call(path, klass, params = {})
    response = @connection.get(path, params)
    data = response.body['data']

    return nil unless data
    data.is_a?(Array) ? Collection.new(response, klass) : klass.new(data)
  end
end
