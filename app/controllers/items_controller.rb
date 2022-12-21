class ItemsController < ApplicationController
  before_action :authenticate_user!
  
  def new
    @challenge = Challenge.find(params[:challenge_id])
    @users = User.where(id: @challenge.target_user)
    @day = params[:day].to_i
    @item = Item.new
    
    @items = @challenge.items.where(day: params[:day])
  
    @days = ["日曜日", "月曜日", "火曜日", "水曜日", "木曜日", "金曜日", "土曜日"]
  end

  def create
    @challenge = Challenge.find(params[:item][:challenge_id])
    if @challenge.status == "one_day"
      day = 7
    else
      day = params[:item][:day].to_i
    end
    report_id = Report.where(day: day).last.id
    @item = Item.new(
      name: params[:item][:name],
      note: params[:item][:note],
      percentage: 0,
      day: day,
      challenge_id: @challenge.id,
      report_id: report_id
    )
    if @item.save
      redirect_to new_item_path(challenge_id: @challenge.id, id: @item.id, status: @challenge.status, day: params[:item][:day]), notice: t('activerecord.attributes.notification.created')
    else
      flash.now[:alert] = t('activerecord.attributes.notification.failed_to_create')
      render 'new'
    end
  end

  def edit
    @item = Item.find(params[:id])
    @challenge = Challenge.find(params[:challenge_id])
  end

  def update
    day = params[:item][:day]
    
    @item = Item.find(params[:item][:id])
    @challenge = Challenge.find(params[:item][:challenge_id])
    @item.update(item_params)
    redirect_to new_item_path(id: @item.id, challenge_id: @challenge.id, status: @challenge.status, day: day)
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
    @report = Report.where(challenge_id: @challenge.id).where(user_id: current_user.id).where(day: @item.day).last
    completed_percentage = @report.completed_percentage  + @item.percentage
    completed_item = ((@report.completed_item.map(&:to_i).push(params[:item_id].to_i).uniq))
    set_percentage = @report.items.pluck(:percentage).sum

    if set_percentage == 0
      total_percentage = 100
    else
      total_percentage = completed_percentage.to_f / set_percentage.to_f * 100
    end

    @report.update(
      completed_percentage: completed_percentage,
      completed_item: completed_item,
      total_percentage: total_percentage
    )

    redirect_to challenge_path(id: params[:challenge_id], status: @challenge.status)
  end

  private
  def item_params
    params.require(:item).permit(:name, :note, :percentage, :challenge_id)
  end
  
end
