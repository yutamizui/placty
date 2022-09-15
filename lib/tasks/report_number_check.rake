namespace :challenges do
  desc "report_number_checker"
  task report_number_check: :environment do
    @challenges = Challenge.where(status: "seven_days")
    @challenges.each do |c|
      @users = User.where(id: c.target_user)
      @users.each do |u|
        @user = User.find(u.id) 
        @reports = Report.where(challenge_id: c, user_id: u.id)
        if @reports.last.target_date != Time.current.beginning_of_day
          Report.create(
            challenge_id: c.id,
            user_id: u.id,
            completed_item: [],
            target_date: Time.current.beginning_of_day
          )
          @reports.first.destroy
        end
      end
    end
  end
end