class EventsController < ApplicationController
  before_action :authenticate_user!, except: %i[show index]
  before_action :set_event, only: %i[show edit update destroy]

  after_action :verify_authorized, only: %i[edit update destroy show]

  def index
    @events = Event.all
  end

  def show
    pincode = params[:pincode] || cookies.permanent["events_#{@event.id}_pincode"]

    event_context = EventContext.new(event: @event, pincode: pincode)

    begin
      authorize event_context, policy_class: EventPolicy

      cookies.permanent["events_#{@event.id}_pincode"] = pincode

      @new_comment = @event.comments.build(params[:comment])
      @new_subscription = @event.subscriptions.build(params[:subscription])
      @new_photo = @event.photos.build(params[:photo])
    rescue Pundit::NotAuthorizedError
      flash.now[:alert] = I18n.t('controllers.events.wrong_pincode')
      render 'password_form'
    end
  end

  def new
    @event = current_user.events.build
  end

  def edit
    authorize @event
  end

  def create
    @event = current_user.events.build(event_params)

    if @event.save
      redirect_to event_path(@event), notice: t('controllers.events.created')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    authorize @event

    if @event.update(event_params)
      redirect_to event_path(@event), notice: t('controllers.events.updated')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @event

    @event.destroy

    redirect_to user_path(current_user), status: :see_other, notice: t('controllers.events.destroyed')
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:title, :address, :datetime, :description, :pincode)
  end
end
