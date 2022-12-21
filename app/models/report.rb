class Report < ApplicationRecord
  belongs_to :challenge
  belongs_to :user
  has_many :items, dependent: :destroy
  serialize :completed_item

end
