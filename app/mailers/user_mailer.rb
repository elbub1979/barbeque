class UserMailer < ApplicationMailer
  def sign_in
    @user = params[:user]

    mail(to: @user.email, subject: "#{t('user_mailer.sign_in.title')} @#{@user.email}")
  end
end

