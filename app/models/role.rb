class Role < ActiveRecord::Base
  serialize :credetials, Hash

  has_many :employees
end
