class EventsController < ApplicationController
  before_action :find_event, only: [:show, :edit, :update, :destroy, :add_point]

  def index
    if current_user.present?
      SendEmail.test_email
      @events = Event.where('date >= ?', Time.now).order(date: "ASC") - current_user.events.where('date >= ?', Time.now) - Event.where(id: current_user.tickets.pluck(:event_id)).where('date >= ?', Time.now)
    else
      @events = Event.where('date >= ?', Time.now).order(date: "ASC")
    end
  end

  def joining 
    @events = Event.where(id: current_user.tickets.pluck(:event_id)).where('date >= ?', Time.now + 60*10).order(date: "ASC") 
  end

  def hosting 
    @events = current_user.events.order(date: "DESC")
  end

  def show
    if current_user.present? 
      @tickets = Ticket.where(user_id: current_user.id).where(event_id: @event.id)
    else
      redirect_to events_path, alert:"ユーザー登録、ログインをしてください"
    end
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    if @event.save
      redirect_to hosting_events_path, notice: t('activerecord.attributes.notification.created')
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
    @event.destroy
    redirect_to hosting_events_path(type: "hosting"), notice: t('activerecord.attributes.notification.deleted')
  end

  def add_point
    @giving_point = params[:giving_point].to_i
    @giving_point.times do
      Point.create(
        user_id: current_user.id,
        expired_at: Date.today.next_year,
      )
    end
    @event.update(
      point_process: true
    )
    redirect_to hosting_events_path, notice: "Sucessfully added"
  end

  def memo 
    @event = Event.find(params[:id])
    @users_id = @event.tickets.pluck(:user_id)
    @users = User.where(id: @users_id)
    @users.each do |u|
      u.notes.first.update(
        content: params[:memo_content] + "\n" + u.notes.first.content 
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
    params.require(:event).permit(:title, :content, :date, :location, :user_id, :length, :point)
  end
end

