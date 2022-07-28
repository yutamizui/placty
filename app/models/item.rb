class Item < ApplicationRecord
  belongs_to :challenge

  validates :name, presence: true
  
end
