class Admin::EmployeesController < Admin::ApplicationController
  before_action :find_employee, only: [:edit, :update, :destroy]

  decorates_assigned :employee, :employees, with: Admin::EmployeeDecorator

  add_breadcrumb :employees, path: proc { admin_employees_path }, with: [:new, :create]

  def index
    @q = Employee.ransack(params[:q])
    @employees = @q.result.order(id: :desc)
  end

  def new
    @employee = Employee.new
  end

  def create
    @employee = Employee.new
    save
  end

  def edit
    add_breadcrumb(employee.name)
  end

  def update
    add_breadcrumb(employee.name)
    save
  end

  def destroy
    @employee.destroy!
    redirect_to admin_employees_path, success: t('flashes.destroy.success')
  end

  private

  def find_employee
    @employee = Employee.find(params[:id])
  end

  def employee_params
    params.require(:employee).permit(
      :email,
      :password,
      :password_confirmation,
      :first_name,
      :last_name,
      role_ids: []
    )
  end

  def save
    @employee.assign_attributes(employee_params)

    if @employee.save
      redirect_to_success admin_employees_path
    else
      render_fail @employee
    end
  end
end
