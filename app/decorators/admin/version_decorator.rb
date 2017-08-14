class Admin::VersionDecorator < Draper::Decorator
  include HumanDates

  delegate_all

  decorates_association :employee, with: Admin::EmployeeDecorator

  def human_employee
    employee.name if employee
  end

  def human_block
    klass = item_type.safe_constantize
    return item_type unless klass
    if klass < ActiveRecord::Base
      klass.model_name.human(default: :other)
    else
      h.t("activemodel.models.#{klass.model_name.element}")
    end
  end

  def human_event
    key = "events.#{event}"
    I18n.exists?(key) ? h.t(key) : event
  end

  def human_item
    return '' unless item
    method = item_type.underscore.tr('/', '_')
    send "#{method}_name"
  end

  def diff
    object_changes.map do |key, diffy|
      [key, Diffy::Diff.new(diffy[0].to_s, diffy[1].to_s).to_s(:html_simple)]
    end.to_h
  end

  private

  def object_changes
    (object.object.present? ? JSON.parse(object.object) : {})
  end

  def qa_question_name
    item.title
  end

  def qa_tag_name
    item.name
  end

  def qa_user_name
    [item.last_name, item.first_name].compact.join(' ')
  end

  def qa_complaint_name
    item.body.truncate(110)
  end

  def qa_answer_name
    item.body.truncate(110)
  end

  def seo_link_name
    item.title
  end

  def employee_name
    [item.last_name, item.first_name].compact.join(' ')
  end

  def images_tag_name
    item.name
  end

  def seo_name
    item.title
  end
end
