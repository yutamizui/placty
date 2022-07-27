class ItemsController < ApplicationController
  def new
    @challenge = Challenge.find(params[:challenge_id])
    @item = Item.new
  end

  def create
    @challenge = Challenge.find(params[:item][:challenge_id])
    @item = Item.new(
      name: params[:item][:name],
      note: params[:item][:note],
      challenge_id: @challenge.id,
      percentage: 0
    )
    if @item.save
      redirect_to challenge_path(id: @challenge.id, status: @challenge.status), notice: t('activerecord.attributes.notification.created')
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
    @item = Item.find(params[:item][:item_id])
    @challenge = Challenge.find(params[:item][:challenge_id])
    @item.update(item_params)
    set_percentage = []
    @challenge.items.each do |i|
      set_percentage << i.percentage * 7
    end
    @set_percentage = set_percentage

    @total_completed_item_id = @challenge.reports.where(user_id: current_user.id).pluck(:completed_item).sum
    completed_percentage = []
    @total_completed_item_id.each do |item_id|
      completed_percentage << Item.find(item_id).percentage
    end
    @completed_percentage = completed_percentage
    
    @challenge.reports.where(user_id: current_user.id).last.update(
      total_percentage: @completed_percentage.sum.to_f / @set_percentage.sum.to_f * 100
    )

    redirect_to challenge_path(id: @challenge.id, status: @challenge.status)
  end

  def destroy
    @challenge = Challenge.find(params[:challenge_id])
    @item = Item.find(params[:item_id])
    @item.destroy
    @challenge.target_user.each do |u|
      @challenge.reports.where(user_id: u).last.update(
        total_percentage: 0,
      )
    end
    redirect_to challenge_path(id: @challenge.id, status: @challenge.status ), notice: t('activerecord.attributes.notification.deleted')
  end

  def report_update
    @item = Item.find(params[:item_id])
    @challenge = Challenge.find(params[:challenge_id])
    @report = @challenge.reports.where(user_id: current_user.id).last

    if @challenge.status == "one_shot"
      @report.update(
        completed_percentage: @report.completed_percentage + @item.percentage,
        completed_item: ((@report.completed_item.map(&:to_i).push(params[:item_id].to_i).uniq)),
        total_percentage: @report.total_percentage + @item.percentage
      )
    else
      
      @report.update(
        completed_percentage: @report.completed_percentage + @item.percentage,
        completed_item: ((@report.completed_item.map(&:to_i).push(params[:item_id].to_i).uniq)),
      )

      set_percentage = []
      @challenge.items.each do |i|
        set_percentage << i.percentage * 7
      end
      @set_percentage = set_percentage

      @total_completed_item_id = @challenge.reports.where(user_id: current_user.id).pluck(:completed_item).sum
      completed_percentage = []
      @total_completed_item_id.each do |item_id|
        completed_percentage << Item.find(item_id).percentage
      end
      @completed_percentage = completed_percentage
      
      @report.update(
        total_percentage: @completed_percentage.sum.to_f / @set_percentage.sum.to_f * 100
      )
    end
    redirect_to challenge_path(id: params[:challenge_id], status: @challenge.status)
  end

  private
  def item_params
    params.require(:item).permit(:name, :note, :percentage, :challenge_id)
  end
  
end
