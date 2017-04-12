class Employee < ActiveRecord::Base
  include Rolable

  has_paper_trail

  devise :database_authenticatable, :rememberable, :validatable
  validates :first_name, :last_name, presence: true

  after_create do
    roles << Role.find_by(name: 'editor') unless role
  end
end
