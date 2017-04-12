class Admin::VersionDecorator < Draper::Decorator
  include HumanDates

  delegate_all

  decorates_association :employee, with: Admin::EmployeeDecorator

  def human_employee
    employee.name if employee
  end

  def human_block
    klass = item_type.safe_constantize
    klass ? klass.model_name.human : item_type
  end

  def human_event
    key = "events.#{event}"
    I18n.exists?(key) ? h.t(key) : event
  end

  def human_item
    if item.respond_to?(:name)
      item.name
    elsif item.respond_to?(:first_name) && item.respond_to?(:last_name)
      [item.last_name, item.first_name].compact.join(' ')
    else
      ''
    end
  end

  def diff
    object_changes.map do |key, diffy|
      [key, Diffy::Diff.new(diffy[0].to_s, diffy[1].to_s).to_s(:html_simple)]
    end.to_h
  end

  private

  def object_changes
    (object.object_changes.present? ? PaperTrail.serializer.load(object.object_changes) : {})
  end
end
