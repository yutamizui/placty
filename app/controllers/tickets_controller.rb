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
      redirect_to events_path(id: params[:event_id]), notice: "このイベントに　参加予定です"
    elsif @event.point == 0
      Ticket.create(
        user_id: @user.id,
        event_id: @event.id,
      )
      redirect_to events_path(id: params[:event_id]), notice: "このイベントに　参加予定です"
    else
      redirect_to events_path(id: params[:public]), alert: "ポイントが不足しています"
    end
    

  end

  def destroy
    @ticket = Ticket.find(params[:ticket_id])
    @ticket.destroy
    redirect_to events_path(type: "joining"), notice: "イベント参加をキャンセルしました。"


  end
end
