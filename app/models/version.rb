class Version < ActiveRecord::Base
  belongs_to :employee

  class << self
    def create_for(loggable, event:)
      create(
        item_id: loggable.id,
        item_type: loggable.class,
        employee_id: Employee.current.id,
        event: event,
        object: loggable.changes.to_json,
        created_at: Time.zone.now
      )
    end
  end

  def item
    @item ||= begin
      type = item_type.safe_constantize
      type.find(item_id) if type
    rescue ActiveRecord::RecordNotFound
      nil
    end
  end
end
