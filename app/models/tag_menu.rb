class TagMenu < ActiveRecord::Base
  self.table_name = 'menu'

  class << self
    alias menu first

    def rebuild(left_side = {}, right_side = {})
      (first || create).update_attributes(
        left_side: left_side, right_side: right_side
      )
    end
  end

  def visible?
    left_side.any? && right_side.any?
  end
end
