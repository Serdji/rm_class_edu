class UserFilter < BaseFilter
  ACCESSORS = %i(
    first_name last_name email user_type
  ).freeze

  attr_accessor(*ACCESSORS)

  class << self
    def user_types
      { fake: 'Отличник', real: 'Ученик' }.invert.to_a
    end
  end

  def apply(relation)
    ACCESSORS.each { |name| send "apply_#{name}" }
    relation.where(filter: result)
  end

  def apply_first_name
    result[:first_name] = first_name if first_name.present?
  end

  def apply_last_name
    result[:last_name] = last_name if last_name.present?
  end

  def apply_email
    result[:emails] = email.downcase if email.present?
  end

  def apply_user_type
    result[:is_fake] = true if fake_users?
    result[:is_fake] = false if real_users?
  end

  def fake_users?
    user_type == 'fake'
  end

  def real_users?
    user_type == 'real'
  end
end
