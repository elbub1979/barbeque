class SendSubscriptionNotification < ActiveJob::Base
  queue_as :event_subscriptions

  def perform(all_emails)
    all_emails.each do |email|
      EventMailer.with(comment: @new_comment, email: email).comment.deliver_now
    end
  end
end