namespace :challenges do
  desc "report_number_checker"
  task report_number_checker: :environment do
    @challenges = Challenge.where(status: "seven_days")
    @challenges.each do |c|
      @users = User.where(id: c.target_user)
      @users.each do |u|
        current_local_time = Time.current.in_time_zone(TimeZone.find(u.time_zone_id).en_name)
        if current_local_time.strftime("%H") == "00"
          day = current_local_time.wday

          target_report = c.reports.where(user_id: u.id).where(day: day).first

          target_report.update(
            completed_item: [],
            completed_percentage: 0.0,
            total_percentage: 0.0,
            target_date: Time.current,
          )

          target_report.items.each do |i|
            Item.update(
              percentage: 0.0,
            )
          end
        end
      end
    end
  end
end