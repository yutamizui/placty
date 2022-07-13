class Report < ApplicationRecord
  belongs_to :challenge
  belongs_to :user
  serialize :completed_item
end
