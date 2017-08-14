class Builder::CSV::UploadFakersInfo
  def initialize(data, windows = false)
    @windows = windows
    @data = data
    @csv = []
  end

  def build
    not_found = @data.delete('not_found_emails_list')

    @data.each do |key, value|
      row = []
      row << I18n.t(key, scope: 'csv_stats')
      row << value

      @csv << row.join(',')
    end

    if not_found.present?
      @csv << ','
      @csv << I18n.t(:not_found_emails_list, scope: 'csv_stats')

      not_found.each { |email| @csv << email }
    end

    result
  end

  def filename
    DateTime.current.strftime('%d.%m.%y_%H-%M-%S.csv')
  end

  private

  def result
    csv = @csv.join("\n")
    csv = csv.encode('cp1251') if @windows
    csv
  end
end
