module Qa::Errorable
  class ErrorStruct < Struct.new(:error)
    def message
      error.fetch(:title)
    end

    def status
      error.fetch(:status)
    end

    def source
      error.fetch(:source)
    end

    def field
      source.split('/').last.to_sym
    end
  end

  def errors
    errors = super

    response_errors.each do |error|
      error = ErrorStruct.new(error)
      errors.add(error.field, error.message)
    end

    self.response_errors = {}
    errors
  end
end
