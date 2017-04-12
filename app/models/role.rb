class Role < ActiveRecord::Base
  has_paper_trail

  serialize :credetials, Hash

  has_many :memberships, dependent: :destroy
  has_many :employees, through: :memberships, source: :rolable, source_type: 'Employee'
  has_many :users, through: :memberships, source: :rolable, source_type: 'User'
end
