class ChallengesController < ApplicationController
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
      @challenges = @one_shot_challenges ## 単発
    elsif params[:status] == "seven_days"
      @challenges = @seven_days_challenges ## ７日間
    end 
  end

  def show
    @challenge = Challenge.find(params[:id])
    @items = @challenge.items
    @days = ["日", "月", "火", "水", "木", "金", "土"]
    @target_report6 = @challenge.reports.where(user_id: current_user.id).last(7).first.total_percentage
    @target_report5 = @challenge.reports.where(user_id: current_user.id).last(6).first.total_percentage
    @target_report4 = @challenge.reports.where(user_id: current_user.id).last(5).first.total_percentage
    @target_report3 = @challenge.reports.where(user_id: current_user.id).last(4).first.total_percentage
    @target_report2 = @challenge.reports.where(user_id: current_user.id).last(3).first.total_percentage
    @target_report1 = @challenge.reports.where(user_id: current_user.id).last(2).first.total_percentage
    @target_report = @challenge.reports.where(user_id: current_user.id).last.total_percentage   # Today's report
  end

  def new
    @challenge = Challenge.new
    if params[:event_id].present?
      @event = Event.find(params[:event_id])
      @users = User.where(id: @event.tickets.pluck(:user_id) )
    end
  end

  def create
    @target_user_ids =  (params[:target_user_id].values.map(&:to_i)).push(params[:author_id].to_i).uniq.sort ## ユーザーの配列
    # @users = User.where(id: @target_user_ids) ## 今回対象のユーザー
    
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
      status: params[:challenge][:status]
    )

    if @challenge.save

      if @challenge.status == "one_shot" && @challenge.reports.count == 0
        @target_user_ids.each do |u|
          Report.create(
            challenge_id: @challenge.id,
            user_id: u,
            completed_item: [],
            target_date: Date.today
          )
        end
      elsif @challenge.status == "seven_days" && @challenge.reports.where(user_id: current_user.id).count == 0
        [0,1,2,3,4,5,6,].each do |i|
          @target_user_ids.each do |u|
            Report.create(
              challenge_id: @challenge.id,
              user_id: u,
              completed_item: [],
              target_date: Date.today-i
            )
          end
        end
      elsif @challenge.status == "seven_days" && @challenge.reports.where(user_id: current_user.id).count > 0
        range = Date.today.beginning_of_day..Date.today.end_of_day ##当日のレポートが存在していないので新規作成
        if @challenge.reports.where(user_id: current_user.id).where(target_date: range).count == 0
          Report.create(
            challenge_id: @challenge.id,
            user_id: current_user.id,
            completed_item: [],
            target_date: Date.today
          )
          @challenge.reports.first.destroy ## 一番古いレポートを数の調整のため削除
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
    redirect_to challenge_path(id: @challenge.id), notice: t('activerecord.attributes.challenge.updated')
  end

  private

  def find_event
    @challenge = Challenge.find(params[:id])
  end

  def challenge_params
    params.require(:challenge).permit(:title, {target_user: []}, :author_id)
  end

end
