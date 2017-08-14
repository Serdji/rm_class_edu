class SeoLink < ActiveRecord::Base
  include Loggable

  validates :url, :title, presence: true

  loggable :all
end
