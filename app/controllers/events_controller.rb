class EventsController < ApplicationController
  before_action :find_event, only: [:show, :edit, :update, :destroy, :add_point, :duplication]
  before_action :authenticate_user!, except: [:index, :show, :memo]

  def index
    @events = Event.where('date >= ?', Time.zone.now-900).order(date: "ASC")  ##現在時刻から１５分をマイナスした時間より大きい開始時間のイベント
    @past_events = Event.where('date < ?', Time.zone.now-900).order(date: "DESC") ##現在時刻から１５分をマイナスした時間より小さい開始時間のイベント
  end

  def joining 
    @events = Event.where(id: current_user.tickets.pluck(:event_id)).where('date >= ?', Time.zone.now-900).order(date: "ASC") 
  end

  def hosting 
    @active_events = current_user.events.where('date >= ?', Time.zone.now-900).order(date: "ASC") ##現在時刻から１５分をマイナスした時間より大きい開始時間のイベント
    @past_events = current_user.events.where('date < ?', Time.zone.now-900).order(date: "DESC") ##現在時刻から１５分をマイナスした時間より小さい開始時間のイベント
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
    year = params[:event]["date(1i)"].to_s
    month = params[:event]["date(2i)"].to_s
    date = params[:event]["date(3i)"].to_s
    hour = params[:event]["date(4i)"].to_s
    min = params[:event]["date(5i)"].to_s
    original_time_zone = Date.today.in_time_zone(TimeZone.find(current_user.time_zone_id).en_name).strftime("%:z")
    @event.date = Time.new(year, month, date, hour, min, "00", original_time_zone).to_time.to_s

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
            expired_at: Date.current.next_year
          )
        end
      end
    end
    ## もし削除のタイミングがイベント開始時間から２４時間以内だった場合
    if Time.zone.now >= @event.date - 1.day
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
        expired_at: Date.current.next_year,
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
    if @users.present?
      @users.each do |u|
        u.notes.first.update(
          content: params[:memo_content] + "\n" + (u.notes.first.content).to_s
        )
      end
      redirect_to event_path(id: @event.id), notice: "イベントメモを送信しました！"
    else
      flash[:notice] = t('activerecord.attributes.link.failed_to_create')
      render 'events/show'
    end
  end

  def how_to_use
  end


  private

  def find_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:title, :content, :location, :user_id, :length, :point, :language_id, :time_limit)
  end
end

