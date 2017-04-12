class Front::ApplicationController < ApplicationController
  rescue_from Front::NotAuthenticatedError, with: :not_authenticated_error
  rescue_from Front::NotFoundError, with: :not_found_error

  helper_method :current_rambler_user
  helper_method :current_user

  protect_from_forgery with: :exception, prepend: true

  # TODO: fix i18n for breadcrumb
  add_breadcrumb :application, path: proc { root_path }

  layout 'front'

  def profile
    if current_user
      render json: current_user.attributes
    else
      head :unauthorized
    end
  end

  # Monitoring by admins
  def root
    render html: '<!DOCTYPE html><html></html>'.html_safe
  end

  private

  def current_user
    @current_user ||= rambler_id_service.internal_user
  end

  def current_rambler_user
    @current_rambler_user ||= rambler_id_service.rambler_user
  end

  def authenticate_user!
    return if current_user && current_user.response_errors.empty?
    raise Front::NotAuthenticatedError
  end

  def rambler_id_service
    @rambler_id_service ||= RamblerIdService.new(rsid)
  end

  def rsid
    if Rails.env.development?
      ENV['RSID'] || cookies[:rsid]
    else
      cookies[:rsid]
    end
  end

  def not_authenticated_error
    render json: { error: 'Not authenticated' }, status: 401
  end

  def not_found_error
    raise ActiveRecord::RecordNotFound
  end

  # NOTE: disable paper trail log
  def user_for_paper_trail
  end
end
