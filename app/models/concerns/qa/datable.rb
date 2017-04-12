module Qa::Datable
  extend ActiveSupport::Concern
  %i(updated_at created_at published_at).each do |method_name|
    define_method method_name do
      self[method_name]&.to_time
    end
  end
end
