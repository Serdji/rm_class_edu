class ImagesController < ApplicationController
  def upload_image
    image = Image.create(image: safe_params)

    if image.errors.any?
      render json: image.errors, status: :unprocessable_entity
    else
      json = { id: image.id, url: image.image_url }
      render json: json
    end
  end

  private

  def safe_params
    params.require(:image)
  end
end
