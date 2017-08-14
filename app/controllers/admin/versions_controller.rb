class Admin::VersionsController < Admin::ApplicationController
  decorates_assigned :versions, :version, with: Admin::VersionDecorator

  add_breadcrumb :versions, path: proc { admin_versions_path }, with: [:show]

  def index
    @q = Version.ransack(params[:q])
    @versions = @q.result
                  .includes(:employee)
                  .order(created_at: :desc)
                  .paginate(per_page: Settings.el_per_page, page: params[:page] || 1)
  end

  def show
    @version = Version.find(params[:id])
  end
end
