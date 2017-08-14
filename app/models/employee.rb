class Employee < ActiveRecord::Base
  include Loggable

  devise :database_authenticatable, :rememberable, :validatable
  validates :first_name, :last_name, :role_id, presence: true

  belongs_to :role

  loggable :all

  class << self
    def current
      RequestStore.store[:current_employee]
    end

    def current=(employee)
      RequestStore.store[:current_employee] = employee
    end
  end

  def has_role?(role_slug)
    role.name == role_slug.to_s
  end
end
