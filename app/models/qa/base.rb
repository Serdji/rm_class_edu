class Qa::Base
  include Her::JsonApi::Model
  include Qa::Errorable
  include Loggable

  class << self
    delegate :limit, to: :scoped
    delegate :order, to: :scoped

    # NOTE: awful hack, her adds unnamed module to ancestors
    def inherited(child)
      child.class_eval do
        %i(updated_at created_at published_at).each do |method_name|
          define_method method_name do
            self[method_name].try :to_time
          end
        end
      end
    end

    def boolean_field(*names)
      names.each do |method_name|
        define_method method_name do
          ActiveRecord::Type::Boolean.new.cast(self[method_name]) || false
        end

        define_method "#{method_name}=" do |value|
          normalized = ActiveRecord::Type::Boolean.new.cast(value)
          super(normalized || false)
        end
      end
    end
  end
end
