module Admin::Concerns
  module Resourcable
    def resource
      instance_variable_get("@#{resource_name}")
    end

    def assign_resource(value)
      instance_variable_set("@#{resource_name}", value)
    end

    def collection
      instance_variable_get("@#{collection_name}")
    end

    def assign_collection(value)
      instance_variable_set("@#{collection_name}", value)
    end

    def resource_name
      resource_class.model_name.element
    end

    def collection_name
      resource_class.model_name.collection
    end
  end
end
