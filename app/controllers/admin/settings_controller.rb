class Admin::SettingsController < Admin::ApplicationController
  PERMIT = ['el_per_page'].freeze

  add_breadcrumb :settings, path: proc { admin_settings_edit_path }

  def edit
    @settings = Settings.get_all.select { |k, _| PERMIT.include? k }
  end

  def update
    params.permit(PERMIT).each do |key, value|
      Settings[key] = value
      redirect_to admin_settings_edit_path
    end
  end
end
