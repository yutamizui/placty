class Item < ApplicationRecord
  belongs_to :challenge
  belongs_to :report
  validates :name, presence: true
  
end
