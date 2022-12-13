class Item < ApplicationRecord
  belongs_to :challenge
  belongs_to :day_frame, optional: true
  validates :name, presence: true
  
end
