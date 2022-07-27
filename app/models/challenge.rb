class Challenge < ApplicationRecord
  serialize :target_user, Array
  has_many :items, dependent: :destroy
  has_many :reports, dependent: :destroy

  enum status: { one_shot: 0, seven_days: 1 }
  enum progress: { awaiting: 0, ongoing: 1 }
end
