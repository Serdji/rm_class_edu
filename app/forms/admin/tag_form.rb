class Admin::TagForm
  include ActiveModel::Model

  TAG_ATTRIBUTES = %w(
    id name slug weight is_published linked_tag_ids
  ).freeze

  attr_accessor(*TAG_ATTRIBUTES)

  attr_reader :seo, :image

  validates :name, presence: true
  validates :weight, inclusion: { in: 1..1000 }

  validate :check_image_presence
  validate :check_image_size

  class << self
    def from_tag(tag)
      attributes = tag.attributes.slice(*TAG_ATTRIBUTES)
      attributes[:linked_tag_ids] = tag.linked_tags.map(&:id)

      attributes[:seo_attributes] = { id: tag.seo.try(:id) }
      attributes[:image_attributes] = { id: tag.image.try(:id) }

      new(attributes)
    end
  end

  def weight=(value)
    @weight = value.to_i if value
  end

  def is_published=(value)
    @is_published = ActiveRecord::Type::Boolean.new.cast(value)
  end

  def linked_tags
    tags = Qa::Tag.where(id: linked_tag_ids).all
    Qa::Tag.tags_for_select(tags)
  end

  def image_attributes=(attributes)
    set_nested_attributes(attributes, Images::Tag, :image)
  end

  def seo_attributes=(attributes)
    set_nested_attributes(attributes, Seo, :seo)
  end

  def build_image
    Images::Tag.new(imageable_type: 'Qa::Tag')
  end

  def build_seo
    Seo.new(seoable_type: 'Qa::Tag')
  end

  def save
    valid? ? persist! : false
  end

  # rubocop:disable Metrics/AbcSize
  def persist!
    tag_attributes = TAG_ATTRIBUTES.map do |name|
      [name, send(name)] unless name == 'id'
    end.compact

    tag = persisted? ? Qa::Tag.find(id) : Qa::Tag.new
    tag.assign_attributes(tag_attributes.to_h)
    tag.save

    if tag.response_errors.empty?
      self.id = tag.id

      image.imageable_id = id
      image.save!

      seo.seoable_id = id
      seo.save!

      true
    end
  end

  def set_nested_attributes(attributes, klass, ivar)
    id = attributes['id'].presence
    model = id ? klass.find(id) : send("build_#{ivar}")
    model.assign_attributes(attributes)
    instance_variable_set("@#{ivar}", model)
  end

  def check_image_presence
    errors.add(:image, :blank) unless image && image.image?
  end

  def check_image_size
    return unless image.try(:image) && image.image.size > 10.megabyte
    errors.add(:image, I18n.t('qa.errors.invalid_size'))
  end

  def persisted?
    id.present?
  end

  def save_url
    id.present? ? :admin_tag : :admin_tags
  end
end
