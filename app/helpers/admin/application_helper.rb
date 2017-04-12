module Admin::ApplicationHelper
  def admin_datepicker_format(timestr)
    time = Time.zone.parse(timestr.to_s)
    time.strftime('%d.%m.%Y %H:%M:%S') if time
  end

  def form_admin_paragraph_path(paragraph)
    if paragraph.id
      admin_paragraph_path(catalog_id: paragraph.catalog_id, id: paragraph.id)
    else
      admin_paragraphs_path(catalog_id: paragraph.catalog_id)
    end
  end

  delegate :has_role?, to: :current_employee
end
