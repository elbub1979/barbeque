class PhotosController < ApplicationController
  before_action :set_event, only: %i[create destroy]
  before_action :set_photo, only: %i[destroy]

  def create
    @new_photo = @event.photos.build(photo_params)
    @new_photo.user = current_user

    if @new_photo.photo.attached? && @new_photo.save
      notify_subscribers(@event, @new_photo)

      redirect_to @event, notice: t("controllers.photos.created")
    else
      render 'events/show', alert: t('controllers.photos.error'), status: :unprocessable_entity
    end
  end

  def destroy
    message = { notice: t("controllers.photos.destroyed"), status: :see_other }

    if current_user_can_edit?(@photo)
      @photo.photo.purge
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

  def set_user_name
    @new_photo.user.name
  end

  def notify_subscribers(event, photo)
    all_emails = (event.subscriptions.map(&:user_email) + [event.user.email]).uniq.reject { |email| email == current_user.email }

    all_emails.each do |email|
      EventMailer.with(event: event, user_email: email, user_name: set_user_name, photo: photo).photo.deliver_now
    end
    EventMailer.with(event: event, user_email: current_user.email, user_name: set_user_name).photo.deliver_now
  end
end
