namespace :challenges do
  desc "report_number_checker"
  task report_number_check: :environment do
    @challenges = Challenge.where(status: "seven_days")
    @challenges.each do |c|
      @users = User.where(id: c.target_user)
      @users.each do |u|
        @user = User.find(u.id) 
        @reports = Report.where(challenge_id: c, user_id: u.id).order(:created_at)
        @last_report = @reports.last ##　レポート新規作成前の最後のレポート
        if Time.current.in_time_zone(TimeZone.find(@user.time_zone_id).en_name).strftime("%H") == "00"
          Report.create(
            challenge_id: c.id,
            user_id: u.id,
            completed_item: [],
            target_date: Time.current,
          )
          @reports.first.destroy ##  -- ここまででレポートの新規作成、一番古いレポートを削除 -- ##

          @latest_last_report = Report.where(challenge_id: c, user_id: u.id).order(:created_at).last##  -- 一番最新のレポートを取得 -- ##
          @set_percentage = c.items.pluck(:percentage).sum * 7
          @total_completed_precentage = c.reports.where(user_id: u.id).pluck(:completed_percentage).sum

          @latest_last_report.update(
            total_percentage: @total_completed_precentage.sum.to_f / @set_percentage.sum.to_f * 100
          )

        end
      end
    end
  end
end