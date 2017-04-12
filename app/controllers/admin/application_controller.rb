class Admin::ApplicationController < ApplicationController
  rescue_from Admin::NotFoundError, with: :not_found

  DEFAULT_LIMIT = 100

  layout 'admin'

  add_flash_types :default, :primary, :success, :info, :warning, :danger

  helper_method :can?

  before_action :authenticate_employee!
  before_action :set_paper_trail_whodunnit
  before_action :check_controllers_credentials

  add_breadcrumb :dashboard, path: proc { admin_root_path }

  rescue_from Admin::AccessDenyError do |_exception|
    head 403
  end

  def current_employee
    Admin::EmployeeDecorator.decorate(super) if super.present?
  end

  def user_for_paper_trail
    current_employee ? current_employee.id : nil
  end

  def can?(controller_name, action_name = 'index')
    # Deny only registered controllers and actions
    credentials = current_employee.role.credentials['controllers']
    credentials.fetch(controller_name.tableize, {}).fetch(action_name, true)
  end

  def page_size_params
    params[:page] = params.fetch(:page, {})
    params[:page][:size] = params[:page].fetch(:size, DEFAULT_LIMIT)
    params.slice(:page, :sort, :filter).permit!
  end

  private

  def redirect_to_success(path)
    redirect_to path, success: t("flashes.#{action_name}.success")
  end

  def render_fail(object)
    flash.now['danger'] = t("flashes.#{action_name}.danger")
    render object.persisted? ? :edit : :new
  end

  def check_controllers_credentials
    return if can?(controller_name, action_name)
    raise Admin::AccessDenyError, 'You haven\'t permission to access'
  end
end
