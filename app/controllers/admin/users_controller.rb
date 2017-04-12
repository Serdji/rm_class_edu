class Admin::UsersController < Admin::ApplicationController
  before_action :find_user, only: [:edit, :update]

  add_breadcrumb :users, path: proc { admin_users_path }

  def index
    @search = UserFilter.new(params[:user_filter])
    @users = @search.apply(Qa::User.where(page_size_params.to_h))
  end

  def edit
    add_breadcrumb @user.full_name
  end

  def update
    @user.assign_attributes(user_params.to_h)

    if @user.save
      redirect_to edit_admin_user_path(@user), success: t("flashes.#{action_name}.success")
    else
      flash.now['danger'] = t("flashes.#{action_name}.danger")
      render :edit
    end
  end

  private

  def user_params
    params = self.params.require(:user)
    params = params.permit(:is_sentry) if can? 'users', 'is_sentry'
    params
  end

  def find_user
    @user = Qa::User.find(params[:id])
    raise Admin::NotFoundError unless @user
  end
end
