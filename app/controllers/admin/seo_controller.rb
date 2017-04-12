class Admin::SeoController < Admin::ApplicationController
  before_action :find_seo, only: [:update, :destroy]

  def update
    save
    render json: @seo
  end

  def create
    @seo = Seo.new
    save
    render json: @seo
  end

  def destroy
    @seo.destroy!
  end

  private

  def save
    @seo.assign_attributes(seo_params)
    @seo.save!
  end

  def seo_params
    params.require(:seo).permit(
      :id, :keywords, :title, :description, :seoable_id, :seoable_type
    )
  end

  def find_seo
    @seo = Seo.find(params[:id])
  end
end
