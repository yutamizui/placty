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
      challenge_id: @challenge.id
    )
    if @item.save
      redirect_to challenge_path(id: @challenge.id), notice: t('activerecord.attributes.notification.created')
    else
      flash.now[:alert] = t('activerecord.attributes.notification.failed_to_create')
      render 'new'
    end
  end

  def destroy
    @item.destroy
    redirect_to challenges_path, notice: t('activerecord.attributes.notification.deleted')
  end

  def report_update
    @report = Challenge.find(params[:challenge_id]).reports.last
    @report.update(
      completed_item: ((@report.completed_item.map(&:to_i).push(params[:item_id].to_i).uniq))
    )
    redirect_to challenge_path(id: params[:challenge_id])
  end
end
