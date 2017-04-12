class Admin::SessionsController < Devise::SessionsController
  layout 'devise'

  private

  def after_sign_in_path_for(_employee)
    admin_root_path
  end

  def after_sign_out_path_for(_employee)
    admin_login_path
  end
end
