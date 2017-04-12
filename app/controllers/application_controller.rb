class ApplicationController < ActionController::Base
  include Concerns::Mobile

  before_action do
    response.headers['Vary'] = 'User-Agent' if mobile_version?
  end

  # TODO: move this to AuthController
  def authenticity_token
    render json: { token: form_authenticity_token }
  end

  # TODO: move this to ImagesController
  def upload_image
    file = Faraday::UploadIO.new(params[:image].path, 'image/jpeg')
    image = Qa::Image.new(image: file)
    image.save

    if image.response_errors.any?
      render json: image.response_errors, status: :unprocessable_entity
    else
      render json: image.attributes.slice('id', 'url')
    end
  end

  private

  def application_facade
    @application_facade ||= ApplicationFacade.new(self)
  end

  helper_method :application_facade

  def menu_service
    @menu_service ||= MenuService.new(self)
  end

  helper_method :menu_service

  def ad_service
    @ad_service ||= AdService.new
  end

  helper_method :ad_service

  def not_found
    raise ActionController::RoutingError, "Path not found: #{request.path}"
  end
end
