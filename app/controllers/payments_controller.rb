class PaymentsController < ApplicationController
  
  def index 
    unless current_user.present?
      redirect_to  new_user_session_path, notice: "ログインしてください。"
    end
    @users = User.where("redeem_point > ?", 0)
  end

  def customer_registration
    if current_user.present?
      @user = current_user
    end

    begin
      if @user.present?
        Payjp.api_key = ENV.fetch("PAYJP_SECRET_KEY")
        customer = Payjp::Customer.create(
          id: "placty" + @user.id.to_s,
          description: @user.en_name,
          card: params['payjp-token'],
          email: @user.email
        )
        @user.update(customer_id: "placty" + @user.id.to_s )
      end

    rescue Payjp::CardError => e
      flash[:alert] = "クレジットカードの認証ができませんでした。1"
      body = e.json_body
      err  = body[:error]

      puts "Status is: #{e.http_status}"
      puts "Type is: #{err[:type]}"
      puts "Code is: #{err[:code]}"
      # param is '' in this case
      puts "Param is: #{err[:param]}"
      puts "Message is: #{err[:message]}"

    rescue Payjp::InvalidRequestError => e
      flash[:alert] = "クレジットカードの認証ができませんでした。"
    rescue Payjp::AuthenticationError => e
      flash[:alert] = "認証キーのエラーが発生しました。運営にお問い合わせください。"
    rescue Payjp::APIConnectionError => e
      flash[:alert] = "接続エラーが発生しました。再度やり直してください。"
    rescue Payjp::PayjpError => e
      flash[:alert] = "通常エラーが発生しました。運営にお問い合わせください。"
    rescue => e
      flash[:alert] = "エラーが発生しました。運営にお問い合わせください。"
    end

    if flash.now[:alert].present?
      render 'payments/index'
    else
      flash[:notice] = "カード情報を登録しました。レッスンポイントをご購入いただけます。"
      redirect_to payments_path
    end
  end

  # ポイント都度購入
  def charge
    @product_type = ProductType.find(params[:product_type_id])
    @point_number = params[:number_of_buying_points].to_i

    Payjp.api_key = ENV.fetch("PAYJP_SECRET_KEY")
    begin
      Payjp::Charge.create(
        amount: @product_type.price * @point_number,
        currency: 'jpy',
        customer: "placty" + current_user.id.to_s,
      )
    rescue Payjp::AuthenticationError => e
      flash[:alert] = "エラーが発生しました。運営にお問い合わせください。(お問い合わせ番号：１)"
    rescue Payjp::APIConnectionError => e
      flash[:alert] = "接続エラーが発生しました。再度やり直してください。(お問い合わせ番号：２)"
    rescue Payjp::PayjpError => e
      flash[:alert] = "エラーが発生しました。運営にお問い合わせください。(お問い合わせ番号：３)"
    rescue => e
      flash[:alert] = "エラーが発生しました。運営にお問い合わせください。(お問い合わせ番号：４)"
    end
    if flash[:alert].present?
      render 'payments/index'
    else
      @point_number.times do
        Point.create!(
          user_id: current_user.id,
          expired_at: Date.current.end_of_day.next_month,
        )
      end
      flash[:notice] = "#{@point_number}ポイントを購入しました。"
      redirect_to payments_path
    end
  end

  def payjpcard_update
    customer_id = "placty#{current_user.id}"

    Payjp.api_key = ENV.fetch("PAYJP_SECRET_KEY")
    customer = Payjp::Customer.retrieve(
      customer_id
    )
    customer.cards.create(
      card: params['payjp-token'],
      default: true
    )
    if flash[:alert].present?
      render 'payments/index'
    else
      flash[:notice] = "カード情報を変更しました。"
      redirect_to payments_path
    end
  end
  
  def redeem_point
    @point_number = current_user.points.count
    current_user.points.each do |p|
      p.destroy
    end
    current_user.update(
      redeem_point: @point_number
    )
    redirect_to payments_path, notice: t('activerecord.attributes.payment.being_redeemed')
  end

  def redeem_completed
    @user = User.find(params[:user_id])
    @user.update(
      redeem_point: 0
    )
    redirect_to payments_path, notice: t('activerecord.attributes.payment.completed')
  end


  def payjp_webhook
  end
end
