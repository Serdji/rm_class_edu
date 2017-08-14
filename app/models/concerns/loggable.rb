module Loggable
  extend ActiveSupport::Concern

  class LogTypes
    def initialize(types)
      @types = types
    end

    def include?(value)
      @types.include?(:all) || @types.include?(value)
    end
  end

  class_methods do
    def loggable(*types)
      types = LogTypes.new(types)

      before_create do
        save_version(:create)
      end if types.include?(:create)

      before_update if: -> { id.present? && changed? } do
        save_version(:update)
      end if types.include?(:update)

      before_destroy do
        save_version(:destroy)
      end if types.include?(:destroy)
    end
  end

  # NOTE: explicitly defined for using with her models
  def changes
    array = changed.map { |attr| [attr, attribute_change(attr)] }
    ActiveSupport::HashWithIndifferentAccess[array]
  end

  private

  def save_version(event)
    return unless Employee.current
    Version.create_for(self, event: event)
  end
end
