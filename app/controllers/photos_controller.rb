class PhotosController < ApplicationController
  before_action :set_event, only: %i[create destroy]
  before_action :set_photo, only: %i[destroy]

  def create
    @new_photo = @event.photos.build(photo_params)
    @new_photo.user = current_user

    if @new_photo.save
      redirect_to @event, notice: t('controllers.photos.created')
    else
      render 'events/show', status: :unprocessable_entity
    end
  end

  def destroy
    message = { notice: t("controllers.photos.destroyed"), status: :see_other }

    if current_user_can_edit?(@subscription)
      @subscription.destroy
    else
      message = { alert: t("controllers.photos.error"), status: :see_other }
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

  # Only allow a list of trusted parameters through.
  def photo_params
    params.fetch(:photo, {}).permit(:photo)
  end
end
