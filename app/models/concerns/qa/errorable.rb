module Qa::Errorable
  extend ActiveSupport::Concern

  def errors
    response_errors&.each do |err|
      key = err[:source].split('/').last.to_sym
      next if super.key? key
      super.add(key, :invalid, message: err[:title])
    end
    super
  end
end
