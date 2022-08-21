class BankAccountsController < ApplicationController
  before_action :find_bank_account, only: [:show, :edit, :update, :destroy]

  def index
    @bank_accounts = BankAccount.all
  end

  def show
  end

  def new
    @bank_account = BankAccount.new
  end

  def create
    @bank_account = BankAccount.new(bank_account_params)
    if @bank_account.save
      redirect_to edit_bank_account_path(id: @bank_account.id), notice: t('activerecord.attributes.notification.created')
    else
      flash.now[:alert] = t('activerecord.attributes.notification.failed_to_create')
      render 'new'
    end
  end

  def edit
  end

  def update
    @bank_account.update(bank_account_params)
    if @bank_account.update(bank_account_params)
      redirect_to edit_bank_account_path(id: @bank_account.id), notice: t('activerecord.attributes.notification.edited')
    else
      flash[:notice] = t('activerecord.attributes.link.failed_to_create')
      render 'events/edit'
    end
  end

  def delete
  end

  private
  def find_bank_account
    @bank_account = BankAccount.find(params[:id])
  end

  def bank_account_params
    params.require(:bank_account).permit(
      :email, :account_holder, :institution_number, :transit_number, :ach_routing_number, :bsb_code, :uk_sort_code,
      :bank_name, :branch_name, :account_type, :account_number, :iban, :currency, :country_name, :city_name, :recipient_address, :post_code, :user_id
    )
  end

end
