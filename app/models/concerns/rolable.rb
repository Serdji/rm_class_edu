module Rolable
  extend ActiveSupport::Concern

  included do
    scope :with_roles, -> (*names) { joins(:roles).where(roles: { name: names }) }

    has_many :memberships, as: :rolable, dependent: :destroy
    has_many :roles, through: :memberships
  end

  def has_role?(role)
    roles.where(name: role).exists?
  end

  def role
    roles.order(:id).first
  end
end
