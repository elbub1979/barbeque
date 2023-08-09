class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    # Дёргаем метод модели, который найдёт пользователя
    @user = User.github_from_omniauth(request.env['omniauth.auth'])

    # Если юзер есть, то логиним и редиректим на его страницу
    if @user.persisted?
      flash[:notice] = I18n.t('devise.omniauth_callbacks.success', kind: 'Github')
      sign_in_and_redirect @user, event: :authentication

      # Если неудачно, то выдаём ошибку и редиректим на главную
    else
      session['devise.github_data'] = request.env['omniauth.auth'].except('extra') # Removing extra as it can overflow some session stores
      flash[:error] = I18n.t(
        'devise.omniauth_callbacks.failure',
        kind: 'Facebook',
        reason: 'authentication error'
      )

      redirect_to root_path
    end
  end

  def google_oauth2
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.google_from_omniauth(request.env['omniauth.auth'])

    if @user.persisted?
      flash[:notice] = I18n.t('devise.omniauth_callbacks.success', kind: 'Google')
      sign_in_and_redirect @user, event: :authentication
    else
      session['devise.google_data'] = request.env['omniauth.auth'].except('extra') # Removing extra as it can overflow some session stores
      flash[:error] = I18n.t(
        'devise.omniauth_callbacks.failure',
        kind: 'Google',
        reason: 'authentication error'
      )

      redirect_to root_path
    end
  end
end
