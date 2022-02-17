class EventsController < ApplicationController
  before_action :find_event, only: [:show, :edit, :update, :destroy, :add_point, :duplication]

  def index
    @events = Event.where('date >= ?', Time.now).order(date: "ASC")
  end

  def joining 
    @events = Event.where(id: current_user.tickets.pluck(:event_id)).where('date >= ?', Time.now + 60*10).order(date: "ASC") 
  end

  def hosting 
    @active_events = current_user.events.where(status: true).order(date: "ASC")
    @inactive_events = current_user.events.where(status: false).order(date: "ASC")
  end

  def show
    if current_user.present? 
      @tickets = Ticket.where(user_id: current_user.id).where(event_id: @event.id)
    end
  end

  def new
    if params[:event_id].present?
      original_event = Event.find(params[:event_id])
      @event = Event.new(
        title: original_event.title,
        content: original_event.content,
        location: original_event.location,
        user_id: original_event.user_id,
        length: original_event.length,
        point: original_event.point,
        limit_number: original_event.limit_number,
        language_id: original_event.language_id,
        status: true
      )
    else
      @event = Event.new
    end
  end

  def create
    @event = Event.new(event_params)
    if @event.save
      redirect_to hosting_events_path, notice: t('activerecord.attributes.notification.created')
    else
      flash.now[:alert] = t('activerecord.attributes.notification.failed_to_create')
      render 'new'
    end
  end

  def edit
  end

  def update
    @event.update(event_params)
    if @event.update(event_params)
      redirect_to hosting_events_path, notice: t('activerecord.attributes.notification.edited')
    else
      flash[:notice] = t('activerecord.attributes.link.failed_to_create')
      render 'events/edit'
    end
  end

  def destroy
    if @event.tickets.count > 0
      @event.tickets.each do |t|
        @event.point.times do
          Point.create(
            user_id: t.user_id,
            expired_at: Date.today.next_year
          )
        end
      end
    end
    ## もし削除のタイミングがイベント開始時間の１日前以降だった場合
    if Time.now >= @event.date - 1.day
      @event.user.update(
        penalty: @event.user.penalty + 1
      )
    end
    ## イベント削除と共にチケットも削除される
    @event.destroy
    redirect_to hosting_events_path, notice: t('activerecord.attributes.notification.deleted')
  end

  def add_point
    @giving_point = params[:giving_point].to_i
    @giving_point.times do
      Point.create(
        user_id: @event.user_id,
        expired_at: Date.today.next_year,
      )
    end
    @event.tickets.destroy_all
    @event.update(status: false)
    redirect_to hosting_events_path, notice: t('activerecord.attributes.notification.point_added')
  end
  

  def memo
    @event = Event.find(params[:id])
    @users_id = @event.tickets.pluck(:user_id)
    @users = User.where(id: @users_id)
    @users.each do |u|
      u.notes.first.update(
        content: params[:memo_content] + "\n" + (u.notes.first.content).to_s 
      )
    end
    redirect_to event_path(id: @event.id), notice: "イベントメモを共有しました！"
    return
  end


  private

  def find_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:title, :content, :date, :location, :user_id, :length, :point, :language_id)
  end
end

