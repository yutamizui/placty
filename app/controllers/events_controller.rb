class EventsController < ApplicationController
  before_action :find_event, only: [:show, :edit, :update, :destroy]

  def index
    @events = Event.where('date >= ?', Time.now).order(date: "ASC")
  end

  def show
  end

  def joining 
    if current_user.present? && current_user.tickets.count > 0
      @events = Event.where(id: current_user.tickets.pluck(:event_id)).where('date >= ?', Time.now).order(date: "ASC")
    end
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    if @event.save
      redirect_to events_path, notice: "Created the community"
    else
      flash.now[:alert] = t('activerecord.attirbutes.activity.failed_to_create')
      render 'new'
    end
  end

  def edit
   
  end

  def update
    @event.update(event_params)
    if @event.update(event_params)
      redirect_to events_path, notice: t('activerecord.attributes.notification.edited')
    else
      flash[:notice] = t('activerecord.attributes.link.failed_to_create')
      render 'events/edit'
    end
  end

  def destroy
    @event.destroy
    redirect_to events_path, notice: t('activerecord.attributes.notification.deleted')
  end

  private

  def find_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:title, :content, :date, :location, :user_id)
  end
end

