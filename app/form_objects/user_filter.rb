class UserFilter < BaseFilter
  attr_accessor :first_name, :last_name

  def apply(relation)
    result = {}

    result[:first_name] = first_name if first_name.present?
    result[:last_name] = last_name if last_name.present?

    relation.where(filter: result)
  end
end
