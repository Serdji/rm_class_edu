class Front::UserDecorator < Draper::Decorator
  delegate_all

  # TODO: move from this
  def full_name
    name = [first_name, last_name].compact.join(' ')
    name.blank? ? "Ученик #{anonymous_id}" : name
  end

  def avatar?
    avatar_url
  end

  def avatar_style
    avatar? ? "background-image: url(#{avatar_url})" : ''
  end
end
