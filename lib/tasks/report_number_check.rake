namespace :challenges do
  desc "report_number_checker"
  task report_number_check: :environment do
    @challenges = Challenge.where(status: "seven_days")
    @challenges.each do |c|
      @users = User.where(id: c.target_user)
      @users.each do |u|
        @user = User.find(u.id) 
        @reports = Report.where(challenge_id: c, user_id: u.id)
        @last_report = @reports.last ##　レポート新規作成前の最後のレポート
        if Time.current.in_time_zone(TimeZone.find(@user.time_zone_id).en_name).strftime("%H") == "00"
          Report.create(
            challenge_id: c.id,
            user_id: u.id,
            completed_item: [],
            target_date: Time.current,
            total_percentage:  @last_report.total_percentage
          )
          @reports.first.destroy
        end
      end
    end
  end
end