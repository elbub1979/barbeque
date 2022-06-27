module EventsHelper
  def user_not_author?(event)
    event.user != current_user
  end

  def event_subscriptions
    @event.subscriptions.except(@new_subscription)
  end

  def not_subscribe?
    @event.visitors.none?(current_user)
  end
end
