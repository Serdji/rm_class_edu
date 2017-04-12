module HumanDates
  extend ActiveSupport::Concern

  included do
    delegate :created_at, :updated_at
  end

  def human_created_at
    human_date(created_at)
  end

  def human_updated_at
    human_date(updated_at)
  end

  private

  def human_date(date)
    format = respond_to?(:date_format, true) ? date_format : :long
    Russian.l(date, format: format)
  end
end
