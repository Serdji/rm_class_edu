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
        object = klass.find(@id, include: 'tags,taggings,user')
        Front::QuestionDecorator.decorate(object)
      when :tags
        klass.find(@id, include: 'image')
    end
  end
end

class SearchIndexJob < ActiveJob::Base
  queue_as :search_index

  def perform(id, options = {})
    @id = id
    @event = options.delete(:event)
    @type = options.delete(:type)

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
