class BaseFilter
  include ActiveModel::Model

  attr_reader :result

  # TODO: may be move this to normalize
  def self.check_box_attributes(*names)
    names.each do |name|
      define_method("#{name}?") do
        send(name) == '1'
      end
    end
  end

  def initialize(attributes = {})
    @result = {}
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
