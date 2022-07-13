class Challenge < ApplicationRecord
  serialize :target_user, Array
  has_many :items
end
