class Front::ApplicationController < ApplicationController
  include Concerns::Captcha

  rescue_from Front::NotAuthenticatedError, with: :not_authenticated_error
  rescue_from Front::NotFoundError, with: :not_found_error

  helper_method :current_user

  protect_from_forgery with: :exception, prepend: true

  # TODO: fix i18n for breadcrumb
  add_breadcrumb :application, path: proc { root_path }

  layout 'front'

  def profile
    if rid.authenticated?
      render json: current_user.try(:attributes) || rid.profile.to_h
    else
      head :unauthorized
    end
  end

  # Monitoring by admins
  # rubocop:disable Rails/OutputSafety
  def root
    render html: '<!DOCTYPE html><html></html>'.html_safe
  end

  private

  def current_user
    @current_user ||= begin
      if rid.authenticated?
        user = rid.find_user_by_chain_ids
        user.sync_with_rid(rid) if user
        user
      end
    end
  end

  def authenticate_user!
    raise Front::NotAuthenticatedError unless rid.authenticated?
  end

  def create_user!
    user = rid.find_user_by_chain_ids
    return unless rid.authenticated? && !user
    @current_user = rid.create_user
  end

  def rambler_id_service
    @rambler_id_service ||= RamblerIdService.new(rsid)
  end

  alias rid rambler_id_service

  def activity_limiter
    @activity_limiter ||= UserActivityLimiter.new(current_user.id)
  end

  def rsid
    cookies[:rsid] || ENV['RSID']
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

  def render_validation_errors(errors)
    render json: { errors: errors }, status: :unprocessable_entity
  end
end
