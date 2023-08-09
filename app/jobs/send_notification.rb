class SendNotification < ActiveJob::Base
  queue_as :default

  def perform(args)
    event = args[:event]
    notification = args[:notification]

    all_emails = (event.subscriptions.map(&:user_email) + [event.user.email] - [notification.user&.email]).uniq

    all_emails.each do |email|
      eval("EventMailer.with(notification: notification, email: email).#{notification.class.name.downcase}.deliver_later")
    end
  end
end
