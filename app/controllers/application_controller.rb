class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action do
    I18n.locale = :ru
  end

  helper_method :current_user_can_edit?
  helper_method :user_author?
  helper_method :already_subscribe

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: %i[password password_confirmation current_password])
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name password password_confirmation current_password])
  end

  def current_user_can_edit?(model)
    user_signed_in? &&
      (model.user == current_user || (model.try(:event).present? && model.event.user == current_user))
  end

  def user_author?(event)
    event.user == current_user
  end
end
