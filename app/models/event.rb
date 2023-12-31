class Event < ApplicationRecord
   has_many :tickets, dependent: :destroy
   belongs_to :user
   belongs_to :language

   validates :title, presence: true
   validates :content, presence: true
   validates :location, presence: true
   validates :length, presence: true
end
