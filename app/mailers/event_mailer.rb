class EventMailer < ApplicationMailer
  def comment
    @comment = params[:comment]
    email = params[:email]

    mail(to: email, subject: "#{t('event_mailer.comment.title')} @ #{@comment.event.title}")
  end

  def subscription
    @subscription = params[:subscription]
    @subscriber_email = @subscription.user_email
    @subscriber_name = @subscription.user_name

    mail(to: @subscriber_email, subject: "#{t('event_mailer.subscription.title')} #{@subscription.event.title}")
  end

  def photo
    @photo = params[:photo]
    @email = params[:email]

    mail(to: @email, subject: "#{t('event_mailer.photo.title')} @ #{@photo.event.title}")
  end
end
