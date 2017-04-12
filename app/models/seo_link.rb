class SeoLink < ActiveRecord::Base
  validates :url, :title, presence: true
end
