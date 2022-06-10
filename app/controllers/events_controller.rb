class EventsController < ApplicationController
  before_action :authenticate_user!, except: %i[show index]
  before_action :set_event, only: %i[show]
  before_action :set_current_user_event, only: %i[edit update destroy]

  def index
    @events = Event.all
  end

  def show
    @new_comment = @event.comments.build(params[:comment])
    @new_subscription = @event.subscriptions.build(params[:subscription])
    @new_photo = @event.photos.build(params[:photo])
  end

  def new
    @event = current_user.events.build
  end

  def edit; end

  def create
    @event = current_user.events.build(event_params)

    if @event.save
      redirect_to event_path(@event), notice: t('controllers.events.created')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @event.update(event_params)
      redirect_to event_path(@event), notice: t('controllers.events.updated')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy

    redirect_to user_path(current_user), status: :see_other, notice: t('controllers.events.destroyed')
  end
end

private

def set_event
  @event = Event.find(params[:id])
end

def set_current_user_event
  @event = current_user.events.find(params[:id])
end

def event_params
  params.require(:event).permit(:title, :address, :datetime, :description, :photo)
end
