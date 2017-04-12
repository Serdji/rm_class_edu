class Qa::User
  include Her::JsonApi::Model
  include Qa::Datable
  include Qa::Relationable

  has_many :questions, class_name: 'Qa::Question'
  has_many :answers, class_name: 'Qa::Answer'

  # TODO: move from this
  def full_name
    name = [first_name, last_name].compact.join(' ')
    name.blank? ? "Ученик #{anonymous_id}" : name
  end
end
