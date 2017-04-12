module Concerns::Mobile
  extend ActiveSupport::Concern

  MOBILE_VIEWS = 'app/views_mobile'.freeze
  DESKTOP_VIEWS = 'app/views_desktop'.freeze

  MOBILE_KEY = 'mobile_version'.freeze
  MOBILE_VERSION = '1'.freeze
  DESKTOP_VERSION = '0'.freeze

  def browser
    @browser ||= Browser.new(request.user_agent)
  end

  def mobile_version?
    return true if cookies[MOBILE_KEY].to_s == MOBILE_VERSION
    return false if cookies[MOBILE_KEY].to_s == DESKTOP_VERSION
    browser.device.mobile?
  end

  def desktop_version?
    !mobile_version?
  end

  def setup_view_path
    view_path = mobile_version? ? MOBILE_VIEWS : DESKTOP_VIEWS
    prepend_view_path view_path
  end

  included do
    before_action :setup_view_path

    helper_method :mobile_version?
    helper_method :desktop_version?
  end
end
