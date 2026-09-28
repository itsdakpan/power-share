class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name])
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || superpowers_path
  end
end
