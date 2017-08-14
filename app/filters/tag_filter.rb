class TagFilter < BaseFilter
  attr_accessor :name

  def apply(relation)
    result = {}

    result[:name] = name

    relation.where(filter: result)
  end
end
