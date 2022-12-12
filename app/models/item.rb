class Item < ApplicationRecord
  belongs_to :challenge
  belongs_to :day_frame
  validates :name, presence: true
  
end
