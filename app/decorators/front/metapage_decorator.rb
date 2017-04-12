class Front::MetapageDecorator < Draper::Decorator
  delegate_all
  delegate :title, :keywords, :description, to: :seo, prefix: true, allow_nil: true

  def seo_title
    object.seo_title ? object.seo_title : title
  end
end
