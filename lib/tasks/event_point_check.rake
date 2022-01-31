namespace :user do
  desc "無料イベント（０ポイント）のポイント追加操作をなくすタスク"
  task event_point_check: :environment do
    @events = Event.where(point_process: false).where(point: 0)
    @events.each do |e|
      if e.date < Date.today
        e.update(point_process: true)
      end 
    end
  end
end