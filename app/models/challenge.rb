class Challenge < ApplicationRecord
  serialize :target_user, Array
  has_many :items
  has_many :reports
end
