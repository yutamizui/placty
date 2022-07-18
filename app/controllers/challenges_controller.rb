class ChallengesController < ApplicationController
  def index
    if params[:name] == "assignment"
      @challenges = Challenge.where(status: 0)
    else
      @challenges = Challenge.where(status: 1)
    end
  end

  def show
    @challenge = Challenge.find(params[:id])

    if @challenge.reports.count == 0
      [0,1,2,3,4,5,6,].each do |i|
        Report.create(
          challenge_id: @challenge.id,
          user_id: current_user.id,
          completed_item: [],
          target_date: Date.today-i
        )
      end
    end

    range = Date.today.beginning_of_day..Date.today.end_of_day
    if @challenge.reports.where(target_date: range).count == 0
      Report.create(
        challenge_id: @challenge.id,
        user_id: current_user.id,
        completed_item: [],
        target_date: Date.today
      )
    end

    @items = @challenge.items
    @target_report6 = @challenge.reports.last(7).first.total_percentage
    @target_report5 = @challenge.reports.last(6).first.total_percentage
    @target_report4 = @challenge.reports.last(5).first.total_percentage
    @target_report3 = @challenge.reports.last(4).first.total_percentage
    @target_report2 = @challenge.reports.last(3).first.total_percentage
    @target_report1 = @challenge.reports.last(2).first.total_percentage
    @target_report = @challenge.reports.last.total_percentage   # Today's report
    @days = ["日", "月", "火", "水", "木", "金", "土"]
  end

  def new
    @challenge = Challenge.new
    if params[:event_id].present?
      @event = Event.find(params[:event_id])
      @users = User.where(id: @event.tickets.pluck(:user_id) )
    end
  end

  def create
    @target_user_ids = params[:target_user_id].values.map(&:to_i) ## ユーザーの配列
    # @users = User.where(id: @target_user_ids) ## 今回対象のユーザー
    @target_date = DateTime.new(params[:challenge]["deadline(1i)"].to_i, params[:challenge]["deadline(2i)"].to_i, params[:challenge]["deadline(3i)"].to_i ,params[:challenge]["deadline(4i)"].to_i ,params[:challenge]["deadline(5i)"].to_i)
    @challenge = Challenge.new(
      title: params[:challenge][:title],
      target_user: @target_user_ids,
      author_id: params[:author_id].to_i,
      deadline: @target_date,
      status: params[:challenge][:status]
    )

    if @challenge.save
      redirect_to challenges_path, notice: t('activerecord.attributes.notification.created')
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
  end

  private

  def find_event
    @challenge = Challenge.find(params[:id])
  end

  def challenge_params
    params.require(:challenge).permit(:title, {target_user: []}, :author_id)
  end

end
