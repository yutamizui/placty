class ItemsController < ApplicationController
  before_action :authenticate_user!
  
  def new
    @challenge = Challenge.find(params[:challenge_id])
    @users = User.where(id: @challenge.target_user)
    @day = params[:day].to_i
    @item = Item.new
    if @challenge.status == "seven_days"
      target_day_frame = @challenge.day_frames.where(day: params[:day])
      @items = Item.where(day_frame_id: target_day_frame)
    else
      @items = Item.where(challenge_id: @challenge.id)
    end
    @days = ["日曜日", "月曜日", "火曜日", "水曜日", "木曜日", "金曜日", "土曜日"]
  end

  def create
    @challenge = Challenge.find(params[:item][:challenge_id])
    day = params[:item][:day].to_i
    day_frame_id = @challenge.day_frames.where(day: day).last.id
    
    if @challenge.status == "one_shot"
      @item = Item.new(
        name: params[:item][:name],
        note: params[:item][:note],
        percentage: 0,
        day_frame_id: @challenge.day_frames.last.id,
        challenge_id: @challenge.id
      )
    else
      @item = Item.new(
        challenge_id: @challenge.id,
        name: params[:item][:name],
        note: params[:item][:note],
        percentage: 0,
        day_frame_id: day_frame_id
      )
    end
    if @item.save
      redirect_to new_item_path(id: @challenge.id, status: @challenge.status, day: params[:item][:day_frame_id], challenge_id: @challenge.id), notice: t('activerecord.attributes.notification.created')
    else
      flash.now[:alert] = t('activerecord.attributes.notification.failed_to_create')
      render 'new'
    end
  end

  def edit
    @item = Item.find(params[:item_id])
    @challenge = Challenge.find(params[:challenge_id])
  end

  def update
    day = params[:item][:day]
    @item = Item.find(params[:item][:item_id])
    @challenge = Challenge.find(params[:item][:challenge_id])
    @item.update(item_params)
    redirect_to new_item_path(challenge_id: @challenge.id, status: @challenge.status, day: day)
  end

  def destroy
    @challenge = Challenge.find(params[:challenge_id])
    @item = Item.find(params[:id])
    @item.destroy
    
    redirect_to new_item_path(id: @item.id, challenge_id: @challenge.id, status: @challenge.status, day: params[:day]), notice: t('activerecord.attributes.notification.deleted')
  end

  def report_update
    @item = Item.find(params[:item_id])
    @challenge = Challenge.find(params[:challenge_id])
    @report = Report.where(day_frame_id: @challenge.day_frames.pluck(:id)).where(user_id: current_user.id).last

    if @challenge.status == "one_shot"
      @report.update(
        completed_percentage: @report.completed_percentage + @item.percentage,
        completed_item: ((@report.completed_item.map(&:to_i).push(params[:item_id].to_i).uniq)),
      )
    else

      @report.update(
        completed_percentage: @report.completed_percentage + @item.percentage,
        completed_item: ((@report.completed_item.map(&:to_i).push(params[:item_id].to_i).uniq)),
      )
      @day_frames = DayFrame.where(id: @challenge.day_frame_id)
      @set_percentage = @challenge.items.pluck(:percentage).sum * 7
      @total_completed_precentage = @challenge.reports.where(user_id: current_user.id).pluck(:completed_percentage).sum

      @report.update(
        total_percentage: @total_completed_precentage.to_f / @set_percentage.to_f * 100
      )
    end
    redirect_to challenge_path(id: params[:challenge_id], status: @challenge.status)
  end

  private
  def item_params
    params.require(:item).permit(:name, :note, :percentage, :challenge_id)
  end
  
end
