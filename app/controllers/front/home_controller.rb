class Front::HomeController < Front::ApplicationController
  decorates_assigned :tags, with: Front::TagDecorator

  helper_method :questions_facade

  def index; end

  def mobile_toggle
    value = if params.fetch(:mobile_force, false)
              MOBILE_VERSION
            else
              mobile_version? ? DESKTOP_VERSION : MOBILE_VERSION
            end
    cookie_switch(value)

    redirect_back fallback_location: root_path
  end

  private

  def questions_facade
    @questions_facade ||= Front::QuestionsFacade.new(self)
  end
end
