class ChallengesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reverse_days, only: [:show]
  before_action :set_days, only: [:show]
  
  def index
    target_challenges = []
    Challenge.all.each do |c|
      if c.target_user.include?(current_user.id)
        target_challenges << c
      end
    end
    @one_shot_challenges = target_challenges.select { |target_challenge| target_challenge[:status] == "one_shot" }
    @seven_days_challenges = target_challenges.select { |target_challenge| target_challenge[:status] == "seven_days" }
    if params[:status] == "one_shot"
      
      @challenges = @one_shot_challenges.sort_by(&:deadline) ## 単発
    elsif params[:status] == "seven_days"
      @challenges = @seven_days_challenges ## ７日間
    end
  end

  def show
    @challenge = Challenge.find(params[:id])
    @users = User.where(id: @challenge.target_user)
    @items = Item.where(challenge_id: @challenge.id)
    if @challenge.status == "seven_days"
      @reports = Report.where(challenge_id: @challenge.id).where(user_id: current_user.id)
      @target_day = Date.today
      @target_report = @reports.where(day: @target_day.wday).first
      @prev_day1 = Date.today.ago(1.days)
      @prev_report1 = @reports.where(day: @prev_day1.wday).first
      @prev_day2 = Date.today.ago(2.days)
      @prev_report2 = @reports.where(day: @prev_day2.wday).first
      @prev_day3 = Date.today.ago(3.days)
      @prev_report3 = @reports.where(day: @prev_day3.wday).first
      @prev_day4 = Date.today.ago(4.days)
      @prev_report4 = @reports.where(day: @prev_day4.wday).first
      @prev_day5 = Date.today.ago(5.days)
      @prev_report5 = @reports.where(day: @prev_day5.wday).first
      @prev_day6 = Date.today.ago(6.days)
      @prev_report6 = @reports.where(day: @prev_day6.wday).first
      

    end
  end

  def new
    @challenge = Challenge.new
    if params[:event_id].present?
      @event = Event.find(params[:event_id])
      @users = User.where(id: @event.tickets.pluck(:user_id) )
      @user_ids = @users.pluck(:id)
    end
  end

  def create
    @target_user_ids =  (params[:target_user_id].values.map(&:to_i)).push(params[:author_id].to_i).uniq.sort ## ユーザーの配列
    @category = params[:status]

    year = params[:challenge]["deadline(1i)"].to_s
    month = params[:challenge]["deadline(2i)"].to_s
    date = params[:challenge]["deadline(3i)"].to_s
    hour = params[:challenge]["deadline(4i)"].to_s
    min = params[:challenge]["deadline(5i)"].to_s

    @target_date = Time.new(year, month, date, hour, min).to_time.to_s
    @challenge = Challenge.new(
      title: params[:challenge][:title],
      target_user: @target_user_ids,
      author_id: params[:author_id].to_i,
      deadline: @target_date,
      status: params[:challenge][:status],
      category: @category
    )

    if @challenge.save
      if @challenge.status == "one_shot"
        @target_user_ids.each_with_index do |u|
          @user = User.find(u)
          Report.create(
            challenge_id: @challenge.id,
            user_id: u,
            completed_item: [],
            target_date: Time.current,
            day: 7
          )
        end
      
        # ７日間チャレンジ
      elsif @challenge.status == "seven_days" # 曜日枠をベースにユーザーごとのレポートを作成
        @target_user_ids.each do |u|
          @user = User.find(u)
          7.times do |n|  ##
            Report.create(
              challenge_id: @challenge.id,
              user_id: u,
              completed_item: [],
              day: n
            )
          end
        end
      end

      redirect_to challenge_path(id: @challenge.id, status: @challenge.status, days: @days), notice: t('activerecord.attributes.notification.created')
    else
      flash.now[:alert] = t('activerecord.attributes.notification.failed_to_create')
      render 'new'
    end
  end

  def edit
  end

  def update
  end

  def destroy
    @challenge = Challenge.find(params[:id])
    @status = @challenge.status
    @challenge.destroy
    redirect_to challenges_path(status: @status )
  end

  def progress
    @challenge = Challenge.find(params[:id])
    @challenge.update(
      progress: "ongoing"
    )
    redirect_to challenge_path(id: @challenge.id,status: @challenge.status), notice: t('activerecord.attributes.challenge.updated')
  end

  private

  def find_event
    @challenge = Challenge.find(params[:id])
  end

  def challenge_params
    params.require(:challenge).permit(:title, {target_user: []}, :author_id)
  end
  
  def set_days
    @days = (0..6).map {|i| Date.today.since(i.days)}
  end

  def set_reverse_days
    @reverse_days = (0..6).map {|i| Date.today.ago(i.days)}
  end 
end
