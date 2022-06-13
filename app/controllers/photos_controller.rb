class PhotosController < ApplicationController
  before_action :set_event, only: %i[create destroy]
  before_action :set_photo, only: %i[destroy]

  def create
    @new_photo = @event.photos.build(photo_params)
    @new_photo.user = current_user

    if @new_photo.save
      EventMailer.with(event: @event, user_email: set_user_email, user_name: set_user_name, photo: @new_photo).photo.deliver_now

      redirect_to @event, notice: t("controllers.photo.created")
    else
      render 'events/show', status: :unprocessable_entity
    end
  end

  def destroy
    message = { notice: t("controllers.photos.destroyed"), status: :see_other }

    if current_user_can_edit?(@photo)
      @photo.destroy
    else
      message = { notice: t("controllers.subscriptions.error"), status: :see_other }
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

  def set_user_email
    @new_photo.user.email
  end

  def set_user_name
    @new_photo.user.name
  end
end
