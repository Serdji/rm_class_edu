class BaseFilter
  include ActiveModel::Model

  def initialize(attributes = {})
    attributes ||= {}

    attributes.permit! if attributes.is_a?(ActionController::Parameters)
    normalize_attributes!(attributes)

    super(attributes)
  end

  def persisted?
    false
  end

  def apply(_relation)
    raise NotImplementedError
  end

  private

  def normalize_attributes!(attributes)
  end
end
