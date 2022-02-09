class Language < ApplicationRecord
  has_many :notice_boards, dependent: :destroy
  has_many :events, dependent: :destroy
end
