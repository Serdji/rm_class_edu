class ApplicationController < ActionController::Base
  include Concerns::Mobile

  before_action do
    response.headers['Vary'] = 'User-Agent' if mobile_version?
  end

  # TODO: move this to AuthController
  def authenticity_token
    render json: { token: form_authenticity_token }
  end

  private

  def application_facade
    @application_facade ||= ApplicationFacade.new(self)
  end

  helper_method :application_facade

  def ad_service
    @ad_service ||= AdService.new
  end

  helper_method :ad_service

  def not_found
    raise ActionController::RoutingError, "Path not found: #{request.path}"
  end
end
