namespace :challenges do
  desc "report_number_check"
  task report_number_check: :environment do
    @challenges = Challenge.where(status: "seven_days")
   
    @challenges.each do |c|
      @users = User.where(id: c.target_user)
      @users.each do |u|
        @user = User.find(u.id) 
        @reports = Report.where(challenge_id: c, user_id: u.id)
        t = @reports.pluck(:target_date)
        unless t.include?(Date.today.end_of_day)
          Report.create(
            challenge_id: c.id,
            user_id: u.id,
            completed_item: [],
            target_date: Date.today.end_of_day
          )
        end
      end
    end
  end
end
