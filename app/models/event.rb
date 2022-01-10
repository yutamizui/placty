class Event < ApplicationRecord
   has_many :tickets
   validates :title, presence: true
   validates :content, presence: true
   validates :location, presence: true
   validates :length, presence: true

   belongs_to :user
end
