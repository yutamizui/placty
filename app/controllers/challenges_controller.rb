class ChallengesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_week, only: [:show]
  
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
    @items = Item.where(day_frame_id: @challenge.day_frames.pluck(:id))
    if @challenge.status == "seven_days"
      @reports = Report.where(day_frame_id: @challenge.day_frames.pluck(:id))
      day_of_week = ["日", "月", "火", "水", "木", "金", "土"]
      @target_day = day_of_week[@days[0].wday]
      @target_day1 = day_of_week[@days[1].wday]
      @target_day2 = day_of_week[@days[2].wday]
      @target_day3 = day_of_week[@days[3].wday]
      @target_day4 = day_of_week[@days[4].wday]
      @target_day5 = day_of_week[@days[5].wday]
      @target_day6 = day_of_week[@days[6].wday]
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
        DayFrame.create(
          challenge_id: @challenge.id,
          day: 7
        )
        @target_user_ids.each_with_index do |u|
          @user = User.find(u)
          Report.create(
            day_frame_id: @challenge.day_frames.first.id,
            user_id: u,
            completed_item: [],
            target_date: Time.current
          )
        end
      
        # ７日間チャレンジ
      elsif @challenge.status == "seven_days"
        7.times do |n|  ## 曜日枠を作成
          DayFrame.create(
            challenge_id: @challenge.id,
            day: n
          )
        end

        @challenge.day_frames.each do |d|    ## 曜日枠をベースにユーザーごとのレポートを作成
          @target_user_ids.each do |u|
            @user = User.find(u)
            Report.create(
              day_frame_id: d.id,
              user_id: u,
              completed_item: [],
              day_frame_id: d.id
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

  def set_week
    @days = (0..6).map {|i| Date.today.since(i.days)}
  end
end
