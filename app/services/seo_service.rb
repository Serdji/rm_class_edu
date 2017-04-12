class SeoService
  class ResolveClassErorr < StandardError
  end

  def initialize(object)
    @object = object

    raise(ResolveClassError, "#{resolve_class_name} is not defined") unless resolve_class
    @generator = resolve_class.new(@object)
  end

  def title
    @generator.title
  end

  def description
    @generator.description
  end

  def keywords
    @generator.keywords
  end

  def seo_attributes
    { title: title, description: description, keywords: keywords }
  end

  private

  def resolve_class
    resolve_class_name.constantize
  end

  def resolve_class_name
    "SeoService::Generators::#{@object.class.name}Generator"
  end
end
