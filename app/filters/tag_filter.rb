class TagFilter < BaseFilter
  attr_accessor :name, :tag_character_id

  def apply(relation)
    result = {}

    result[:name] = name if name.present?
    result[:tag_character_id] = tag_character_id if tag_character_id.present?

    relation.where(filter: result)
  end
end
