class InvoicesController < ApplicationController

  def index
    @user = current_user
  end

  def create
    type = params[:type]
    event_number = params[:event_number]
    participant_number = params[:participant_number]
    total_point = params[:total_point]
    sales = params[:sales]

    Invoice.create(
      user_id: current_user.id,
    )
    redirect_to invoices_path
  end



  def delete
  end
end