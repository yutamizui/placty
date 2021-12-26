class TicketsController < ApplicationController
  
  def create
    @event = Event.find(params[:event_id])
    @user = User.find(params[:user_id])
    @points = @user.points
    
    ## イベントが有料でユーザーが必要ポイントを持っている時
    if @event.point > 0 && @points.count >= @event.point

      @points.first(@event.point).each do |p|
        p.destroy
      end

      Ticket.create(
        user_id: @user.id,
        event_id: @event.id,
      )
      redirect_to events_path(id: params[:event_id]), notice: "このイベントに参加予定です"
    elsif @event.point == 0
      Ticket.create(
        user_id: @user.id,
        event_id: @event.id,
      )
      redirect_to events_path(id: params[:event_id]), notice: "このイベントに参加予定です"
    else
      redirect_to events_path(id: params[:public]), alert: "ポイントが不足しています。アカウントよりポイントを追加してください"
    end
  end

  def destroy
    @ticket = Ticket.find(params[:ticket_id])
    @event = Event.find(@ticket.event_id)
    @user = User.find(@ticket.user_id)
    
    ## もしユーザーがポイントを持っていれば、最後のポイントの期限日を反映、ポイントがない場合は１ヶ月後
    if @user.points.count > 0
      expired_at = @user.points.last.expired_at
    else
      expired_at = Date.today.end_of_day.next_month
    end
    @ticket.destroy
    @event.point.times do
      Point.create(
        user_id: @user.id,
        expired_at: expired_at,
      )
    end
    redirect_to events_path(type: "joining"), notice: "イベント参加をキャンセルしました。"
  end
end
