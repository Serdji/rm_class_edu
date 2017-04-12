class Admin::RoleDecorator < Draper::Decorator
  delegate_all

  def human_name
    h.t("roles.#{name}")
  end
end
