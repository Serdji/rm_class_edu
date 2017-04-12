module ActionControllerExt
  module Breadcrumbs
    def self.included(klass)
      klass.extend ClassMethods

      klass.class_eval do
        helper_method :breadcrumbs
      end
    end

    module ClassMethods
      def add_breadcrumb(name, options = {})
        before_action(build_params(options)) do
          @breadcrumbs ||= []
          @breadcrumbs << ::ActionControllerExt::Breadcrumb.new(self, name, options)
        end

        with = options.delete(:with)
        if with
          Array(with).each do |action|
            before_action only: action do
              @breadcrumbs << ::ActionControllerExt::Breadcrumb.new(self, action)
            end
          end
        end
      end

      private

      def build_params(options)
        {}.tap do |params|
          only = options.delete(:only)
          params[:only] = Array(only) if only
        end
      end
    end

    private

    def add_breadcrumb(name, options = {})
      @breadcrumbs << ::ActionControllerExt::Breadcrumb.new(self, name, options)
    end

    def breadcrumbs
      @breadcrumbs
    end
  end
end
