class CrudableArguments
  attr_reader :args

  cattr_accessor :default_actions
  self.default_actions = %i(index new create show edit update destroy)

  def initialize(args)
    @args = args.with_indifferent_access
  end

  def resource
    args.fetch(:with)
  end

  def singular_name
    resource_name.underscore
  end

  def plural_name
    singular_name.pluralize
  end

  def auth_model
    args[:auth]
  end

  def authenticate?
    !!auth_model
  end

  delegate :name, to: :resource, prefix: true

  def actions
    return default_actions & only if only.any?
    return default_actions - except if except.any?

    default_actions
  end

  private

  def except
    Array(args[:except] || [])
  end

  def only
    Array(args[:only] || [])
  end
end
