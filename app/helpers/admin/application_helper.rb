module Admin::ApplicationHelper
  def admin_datepicker_format(timestr)
    time = Time.zone.parse(timestr.to_s)
    time&.strftime('%d.%m.%Y %H:%M:%S')
  end

  def form_admin_paragraph_path(paragraph)
    if paragraph.id
      admin_paragraph_path(catalog_id: paragraph.catalog_id, id: paragraph.id)
    else
      admin_paragraphs_path(catalog_id: paragraph.catalog_id)
    end
  end

  def years_options
    Range.new(2017, Time.zone.now.year).map { |x| [x, x] }
  end

  def monthes_options
    Range.new(1, 12).map { |x| [t('date.canonical_month_names')[x], x] }
  end

  delegate :has_role?, to: :current_employee
end
