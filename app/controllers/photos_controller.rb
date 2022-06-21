class PhotosController < ApplicationController
  before_action :set_event, only: %i[create destroy]
  before_action :set_photo, only: %i[destroy]

  def create
    @new_photo = @event.photos.build(photo_params)
    @new_photo.user = current_user

    if @new_photo.photo.attached? && @new_photo.save
      notify_subscribers(@event)

      redirect_to @event, notice: t("controllers.photos.created")
    else
      render 'events/show', alert: t('controllers.photos.error'), status: :unprocessable_entity
    end
  end

  def destroy
    message = { notice: t("controllers.photos.destroyed"), status: :see_other }

    if current_user_can_edit?(@photo)
      @photo.destroy
    else
      message = { alert: t("controllers.subscriptions.error"), status: :see_other }
    end

    redirect_to @event, message
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def set_photo
    @photo = @event.photos.find(params[:id])
  end

  def photo_params
    params.fetch(:photo, {}).permit(:event, :photo)
  end

  def notify_subscribers(event)
    all_emails = (event.subscriptions.map(&:user_email) + [event.user.email] - [@new_photo.user&.email]).uniq

    all_emails.each do |email|
      EventMailer.with(email: email, photo: @new_photo).photo.deliver_now
    end
  end
end

