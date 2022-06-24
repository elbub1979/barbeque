module EventsHelper
  def user_author?(event)
    event.user == current_user
  end

  def event_subscriptions
    @event.subscriptions.exists?
  end

  def already_subscribe
    @event.visitors.include?(current_user)
  end
end
