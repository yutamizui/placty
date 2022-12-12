class Challenge < ApplicationRecord
  serialize :target_user, Array
  has_many :items, dependent: :destroy
  has_many :reports, dependent: :destroy
  has_many :day_frames, dependent: :destroy

  enum status: { one_shot: 0, seven_days: 1 }
  enum progress: { awaiting: 0, ongoing: 1 }
  enum category: { personal: 0, shared: 1 }

  validates :title, presence: true
end
