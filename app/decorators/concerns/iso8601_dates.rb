module Iso8601Dates
  extend ActiveSupport::Concern

  def iso8601
    created_at.in_time_zone.iso8601
  end
end
