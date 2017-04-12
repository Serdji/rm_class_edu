module ObjectPublished
  extend ActiveSupport::Concern

  def published_class
    object.respond_to?(:published?) && object.published? ? 'fa-eye' : 'fa-eye-slash'
  end
end
