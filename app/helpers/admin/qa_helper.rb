class QaSortLinkBuilder
  ASC_ARROW = '&#9650;'.freeze
  DESC_ARROW = '&#9660;'.freeze

  class << self
    def build_link(attribute, context)
      new(attribute, context).build_link
    end
  end

  attr_reader :attribute, :context, :translated

  alias c context

  def initialize(attribute, context)
    @attribute = attribute.to_s
    @context = context
    @translated = translate_attribute
  end

  def build_link
    c.link_to build_title, build_params
  end

  private

  def build_title
    if sort_enabled?
      arrow = ascend? ? ASC_ARROW : DESC_ARROW
      # rubocop:disable Rails/OutputSafety
      "#{translated} #{arrow}".html_safe
    else
      translated
    end
  end

  def build_params
    result = (sort_enabled? && ascend?) ? "-#{attribute}" : attribute
    params.merge(sort: result)
  end

  def params
    @params ||= c.params.permit!.to_h
  end

  def sort_enabled?
    params[:sort] && params[:sort].tr('-', '') == attribute
  end

  def ascend?
    !params[:sort].start_with?('-')
  end

  def translate_attribute
    resource = params['controller'].split('/').last.singularize
    klass = "Qa::#{resource.capitalize}".constantize
    klass.human_attribute_name(attribute)
  end
end

module Admin::QaHelper
  def qa_sort_link(name)
    QaSortLinkBuilder.build_link(name, self)
  end

  def qa_tags_for_select(additional_tags = nil)
    current = additional_tags ? additional_tags : []
    current = current.map { |t| [t.name, t.id] }

    (current + Qa::Tag.published.map { |t| [t.name, t.id] }).uniq
  end
end
