class Front::HomeController < Front::ApplicationController
  decorates_assigned :tags, with: Front::TagDecorator

  helper_method :questions_facade

  def index; end

  def mobile_toggle
    cookie_switch(mobile_cookie)
    redirect_back fallback_location: root_path
  end

  private

  def questions_facade
    @questions_facade ||= Front::QuestionsFacade.new(self)
  end

  def mobile_cookie
    if params.fetch(:mobile_force, false)
      MOBILE_VERSION
    else
      mobile_version? ? DESKTOP_VERSION : MOBILE_VERSION
    end
  end
end
