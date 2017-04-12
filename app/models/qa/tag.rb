class Qa::Tag
  include Her::JsonApi::Model

  include Seoable

  include Qa::Datable
  include Qa::Relationable
  include Qa::QaSeoable
  include Qa::Errorable

  has_many :linked_tags, class_name: 'Qa::Tag'
  has_many :questions, class_name: 'Qa::Question'

  has_one :image, class_name: 'Qa::Image'

  validates :name, presence: true

  validate :validate_image_presence
  validate :validate_image_size

  # TODO: implement it in json api
  # instead of hardcoded scopes
  scope :has_questions, -> { where(has_questions: true) }

  scope :published, -> { where(filter: { is_published: true }) }
  scope :hidden, -> { where(filter: { is_published: false }) }

  class << self
    # TODO: remove this depricated method
    def tags_for_select(additional_tags = nil)
      current = additional_tags ? additional_tags : []
      current = current.collect { |t| [t.name, t.id] }

      (all.collect { |t| [t.name, t.id] } + current).uniq
    end

    def find_by_slug(slug, params = {})
      get_resource("tags/slug/#{slug}", params) if slug
    end

    def search(search, limit = 7)
      where page: { size: limit }, filter: { name: search }
    end
  end

  def linked_tag_ids
    @attributes[:linked_tag_ids] ||= linked_tags.map(&:id)
  end

  def linked_tag_ids=(ids)
    @attributes[:linked_tag_ids] = ids
  end

  def image_attributes=(attributes)
    @attributes[:image] = build_image(attributes)
    @attributes[:image_attributes] = attributes
  end

  def image
    @attributes[:image] && super
  end

  def build_image(attributes = {})
    Qa::Image.new(attributes.merge(imageable_id: id, imageable_type: 'Tag'))
  end

  private

  def validate_image_presence
    return if image.try(:id).present?
    errors.add(:image, :blank) unless image.try(:image)
  end

  def validate_image_size
    return unless image.try(:image) && image.image.size > 10.megabyte
    errors.add(:image, I18n.t('qa.errors.invalid_size'))
  end
end
