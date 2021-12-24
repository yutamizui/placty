class PaymentsController < ApplicationController
  
  def index 
    unless current_user.present?
      redirect_to  new_user_session_path, notice: "ログインしてください。"
    end
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
          expired_at: Date.today.end_of_day.next_month,
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

  # ## 毎月自動引き落とし
  # def subscribe
  #   @product_type = ProductType.find(params[:id])
  #   @student = current_student
  #   Payjp.api_key = ENV.fetch("PAYJP_SECRET_KEY")
  #   begin
  #     Payjp::Subscription.create(
  #       plan: @product_type.plan,
  #       customer: @student.customer_id,
  #     )

  #   rescue Payjp::AuthenticationError => e
  #     flash[:alert] = "エラーが発生しました。運営にお問い合わせください。(お問い合わせ番号：１)"
  #   rescue Payjp::APIConnectionError => e
  #     flash[:alert] = "接続エラーが発生しました。再度やり直してください。(お問い合わせ番号：２)"
  #   rescue Payjp::PayjpError => e
  #     flash[:alert] = "エラーが発生しました。運営にお問い合わせください。(お問い合わせ番号：３)"
  #   rescue => e
  #     flash[:alert] = "エラーが発生しました。運営にお問い合わせください。(お問い合わせ番号：４)"
  #   end

  #   if flash[:alert].present?
  #     render 'payments/price'
  #   elsif @product_type.plan == 'hop'
  #     @student.update(
  #       subscription: "hop",
  #       start_day: Date.today
  #     )
  #     32.times do
  #       Point.create!(
  #         student_id: @student.id,
  #         expired_at: Date.today.next_month,
  #       )
  #     end
  #     flash[:notice] = "プランを開始しました。"
  #     redirect_to root_path

  #   elsif @product_type.plan == "step"
  #     @student.update(
  #       subscription: "step",
  #       start_day: Date.today
  #     )
  #     68.times do
  #       Point.create!(
  #         student_id: @student.id,
  #         expired_at: Date.today.next_month,
  #       )
  #     end
  #     flash[:notice] = "プランを開始しました。"
  #     redirect_to root_path #'https://www.calahe.com/'
  #   end
  # end


  

  # # プランをやめる時
  # def unsubscribe
  #   @product_type = ProductType.find(params[:id])
  #   @student = current_student
  #   Student.transaction do
  #     Payjp.api_key = ENV.fetch("PAYJP_SECRET_KEY")
  #     customer = Payjp::Customer.retrieve(
  #       "your_english_student" + @student.id.to_s,
  #     )

  #     subscription_id = customer[:subscriptions].pluck(:id).join()
  #     subscription = Payjp::Subscription.retrieve(subscription_id)
  #     @student.update!(
  #       subscription: "nothing",
  #       start_day: nil
  #     )

  #     unless subscription.delete
  #       raise "RunTimeError??"
  #     end

  #     flash[:notice] = @product_type.name + "を解約しました。"
  #     redirect_to payments_price_path

  #   end
  # rescue StandardError => e
  #   ## エラー通知 err bit
  #   flash[:alert] = "プラン変更ができませんでした。運営にお問い合わせください。"
  #   render 'payments/price'
  # end


  

  def payjp_webhook
  end
end
