class Admin::MetapagesController < Admin::ApplicationController
  # include Admin::Concerns::Resourcable

  decorates_assigned :metapages, with: Admin::MetapageDecorator
  decorates_assigned :metapage, with: Admin::MetapageDecorator

  before_action :find_metapage, only: [:update, :destroy, :edit]

  def index
    @q = Metapage.includes(:metapages_type).ransack(params[:q])
    @metapages = @q.result.ordered
  end

  def update
    save
  end

  def edit
    @metapages = Metapage.includes(:metapages_type).ordered
  end

  private

  def metapage_params
    params.require(:metapage).permit(
      :id, :label, :title, :description,
      seo_attributes: [:id, :title, :description, :keywords, :_destroy]
    )
  end

  def save
    @metapage.assign_attributes(metapage_params)

    if @metapage.save
      redirect_to admin_metapages_path, success: t("flashes.#{action_name}.success")
    else
      flash.now['danger'] = t("flashes.#{action_name}.danger")
      render @metapage.persisted? ? :edit : :new
    end
  end

  def find_metapage
    @metapage ||= Metapage.find(params[:id])
  end
end
