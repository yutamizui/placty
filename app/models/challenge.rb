class Challenge < ApplicationRecord
  serialize :target_user, Array
  has_many :items, dependent: :destroy
  has_many :reports, dependent: :destroy

  enum status: { assignment: 0, seven_days: 1 }
end
