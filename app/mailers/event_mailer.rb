class EventMailer < ApplicationMailer
  default from: 'mybarbeque2022@gmail.com'

  def subscription
    @subscriber_email = params[:subscriber_email]
    @subscriber_name = params[:subscriber_name]
    @event = params[:event]

    mail(to: @event.user.email, subject: "Новая подписка на #{@event.title}")
  end

  def comment
    @comment = params[:comment]
    @event = params[:event]
    email = params[:email]

    mail(to: email, subject: "Новый комментарий @ #{@event.title}")
  end

  def photo
    @photo = params[:photo]
    @email = params[:user_email]
    @name = params[:user_name]
    @event = params[:event]

    mail(to: @event.user.email, subject: "Новое фото @ #{@event.title}")
  end
end
