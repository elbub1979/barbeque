class SendSubscriptionNotification < ActiveJob::Base
  queue_as :event_subscriptions

  def perform(all_emails, comment)
    all_emails.each do |email|
      EventMailer.with(comment: comment, email: email).comment.deliver_now
    end
  end
end