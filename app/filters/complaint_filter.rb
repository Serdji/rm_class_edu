class ComplaintFilter < BaseFilter
  attr_accessor :body, :complainable_type

  def apply(relation)
    result[:body] = body if body.present?
    result[:complainable_type] = complainable_type if complainable_type.present?

    relation.where(filter: result)
  end
end
