class Membership < ActiveRecord::Base
  has_paper_trail

  belongs_to :role
  belongs_to :rolable, polymorphic: true
end
