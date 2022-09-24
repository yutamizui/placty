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
          )

          @reports.first.destroy

          @report = c.reports.where(user_id: @user.id).last
          set_percentage = []
          c.items.each do |i|
            set_percentage << i.percentage * 7
          end
          @set_percentage = set_percentage

          @total_completed_item_id = c.reports.where(user_id: @user.id).pluck(:completed_item).sum
          completed_percentage = []
          @total_completed_item_id.each do |item_id|
            completed_percentage << Item.find(item_id).percentage
          end
          @completed_percentage = completed_percentage

          @report.update(
            total_percentage: @completed_percentage.sum.to_f / @set_percentage.sum.to_f * 100
          )

        end
      end
    end
  end
end