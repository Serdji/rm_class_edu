class Qa::MultiTag < Qa::Base
  include Qa::Seoable

  loggable :all

  has_many :tags, class_name: 'Qa::Tag'

  def tags!(options = {})
    Qa::MultiTag.get_collection("multi_tags/#{id}/tags", options) if id
  end

  def tag_ids
    @attributes[:tag_ids] ||= tags.map(&:id)
  end

  def tag_ids=(ids)
    ids = ids.is_a?(Array) ? ids.reject(&:blank?) : []
    @attributes[:tag_ids] = ids
  end

  def tags?
    tag_ids.present?
  end

  boolean_field :is_published
end
