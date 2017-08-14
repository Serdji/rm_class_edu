class Membership < ActiveRecord::Base
  belongs_to :role
  belongs_to :rolable, polymorphic: true
end
