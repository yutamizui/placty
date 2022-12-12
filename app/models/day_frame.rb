class DayFrame < ApplicationRecord
  belongs_to :challenge
  has_many :items, dependent: :destroy
end
