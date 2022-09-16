namespace :challenges do
  desc "report_number_checker"
  task report_number_check: :environment do
    @challenges = Challenge.where(status: "seven_days")
    @challenges.each do |c|
      @users = User.where(id: c.target_user)
      @users.each do |u|
        @user = User.find(u.id) 
        @reports = Report.where(challenge_id: c, user_id: u.id)
        if Report.last.target_date.next_day.strftime("%Y-%m-%d-%H:00:00") == Time.current.to_datetime.strftime("%Y-%m-%d-%H:00:00") 
          Report.create(
            challenge_id: c.id,
            user_id: u.id,
            completed_item: [],
            target_date: Time.current.to_datetime.strftime("%Y-%m-%d-%H:00:00")
          )
          @reports.first.destroy
        end
      end
    end
  end
end