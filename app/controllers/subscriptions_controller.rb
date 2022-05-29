class SubscriptionsController < ApplicationController
  before_action :set_event, only: %i[create destroy]
  before_action :set_subscription, only: %i[destroy]
  def create
    @new_subscription = @event.subscriptions.build(subscription_params)
    @new_subscription.user = current_user

    if @subscription.save
      redirect_to @event, notice: t("controller.subscription.created")
    else
      render 'events/show', alert: t("controller.subscription.error")
    end
  end

  def destroy
    message = { notice: t("controller.subscriptions.destroy") }

    if current_user_can_edit?(@subscription)
      @subscription.destroy
    else
      message = { notice: t("controller.subscriptions.error") }
    end

    redirect_to @event, message
  end

  private

  def set_subscription
    @subscription = @event.subscription.find(params[:id])
  end

  def set_event
    @event = Event.find(params[:event_id])
  end

  def subscription_params
    params.fetch(:subscription, {}).permit(:user_name, :user_email)
  end
end
