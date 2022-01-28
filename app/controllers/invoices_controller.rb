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
      note:  ("☆ #{Date.today.strftime("%m/%d (#{%w(日 月 火 水 木 金 土)[Date.today.wday]}),")}  \n\n\n#{t('activerecord.attributes.invoice.event_number')}: #{event_number},\n\n\n" "#{t('activerecord.attributes.invoice.participant_number')}: #{participant_number},\n\n\n" "#{t('activerecord.attributes.invoice.point_number')}: #{total_point},\n\n\n" + "#{t('activerecord.attributes.invoice.sales')}: #{sales}#{t('activerecord.attributes.invoice.yen')}" ) 
    )
    redirect_to invoices_path
  end



  def delete
  end
end