class ApplicationController < ActionController::Base
  include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :configure_permitted_parameters, if: :devise_controller?
  # before_action I18n.locale = :ru

  helper_method :current_user_can_edit?
  helper_method :current_user_present?

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: %i[password password_confirmation current_password])
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name password password_confirmation current_password])
  end

  def current_user_can_edit?(model)
    user_signed_in? &&
      (model.user == current_user || (model.try(:event).present? && model.event.user == current_user))
  end

  def current_user_present?
    current_user
  end

  private

  def user_not_authorized
    flash[:alert] = t('pundit.not_authorized')
    redirect_to (request.referrer || root_path), status: :see_other
  end
end
