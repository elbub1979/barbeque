class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action do
    I18n.locale = :ru
  end

  helper_method :current_user_can_edit?

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: %i[password password_confirmation current_password])
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name password password_confirmation current_password])
  end

  def current_user_can_edit?(event)
    user_signed_in? && event.user == current_user
  end
end
