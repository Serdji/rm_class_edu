class SearchIndexBuilder
  attr_reader :object

  def initialize(id, type)
    @id = id
    @type = type
  end

  def call
    adapter.as_json
  end

  private

  def adapter
    ActiveModelSerializers::Adapter.create(serializer, adapter: :attributes)
  end

  def serializer
    klass = "#{@type.to_s.classify.pluralize}::SearchIndexSerializer".constantize
    klass.new(object)
  end

  def object
    klass = "View::Qa::#{@type.to_s.singularize.camelize}".constantize

    case @type
      when :questions
        object = klass.find(@id, include: 'tags,user')
        Front::QuestionDecorator.decorate(object)
      when :tags
        klass.find(@id)
    end
  end
end

class SearchIndexJob < ActiveJob::Base
  queue_as :search_index

  def perform(id, options = {})
    @id = id

    options.symbolize_keys!

    event = options.delete(:event)
    type = options.delete(:type)

    raise ArgumentError, 'event and type must exists' unless event && type

    @event = event.to_sym
    @type = type.to_sym

    SearchService.index(build_attributes)
  end

  def build_attributes
    case @event
      when :update, :create
        SearchIndexBuilder.new(@id, @type).call
      when :destroy
        { id: @id, type: @type, is_published: false }
    end
  end
end
