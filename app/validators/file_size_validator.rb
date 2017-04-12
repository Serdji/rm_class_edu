class FileSizeValidator < ActiveModel::EachValidator
  METHODS = {
    less: '<',
    less_or_equal: '<='
  }.freeze

  def validate_each(record, attribute, value)
    check_options!
    return if value.file.blank?

    record.errors.add(attribute, :invalid_size) unless compare_size(value.file)
  end

  private

  def compare_size(file)
    method = METHODS[option_method]
    file.size.send(method, option_value)
  end

  def check_options!
    options_size = current_option.size
    if options_size == 0 || options_size == 2
      raise "Only one option (#{OPTION_KEYS.join(' or ')}) must present"
    end
  end

  def option_method
    current_option.keys.first
  end

  def option_value
    current_option.values.first
  end

  def current_option
    options.slice(*METHODS.keys)
  end
end
