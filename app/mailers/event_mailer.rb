class EventMailer < ApplicationMailer
  default from: 'mybarbeque2022@gmail.com'

  def subscription
    @subscription = params[:subscription]
    @subscriber_email = set_user_email
    @subscriber_name = set_user_name

    mail(to: @subscriber_email, subject: "#{t('event_mailer.subscription.title')} #{@subscription.event.title}")
  end

  def comment
    @comment = params[:comment]
    email = params[:email]

    mail(to: email, subject: "#{t('event_mailer.comment.title')} @ #{@comment.event.title}")
  end

  def photo
    @photo = params[:photo]
    @email = params[:user_email]
    @name = params[:user_name]

    mail(to: @email, subject: "#{t('event_mailer.photo.title')} @ #{@photo.event.title}")
  end

  private

  def set_user_email
    @subscription.user_email || @subscription.user.email
  end

  def set_user_name
    @subscription.user_name || @subscription.user.name
  end
end
