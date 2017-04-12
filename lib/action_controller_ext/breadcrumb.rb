module ActionControllerExt
  class Breadcrumb
    def initialize(controller, name, options = {})
      @controller = controller
      @name = name
      @options = options
    end

    def human_name
      if options[:path]
        name = @name.to_s.singularize
        I18n.t(name, scope: [:activerecord, :models], default: name)
      else
        I18n.t(@name, scope: [:label], default: @name)
      end
    end

    def path
      return unless (path = options[:path])
      path.is_a?(Proc) ? controller.instance_eval(&path) : path
    end

    private

    attr_reader :controller, :options
  end
end
