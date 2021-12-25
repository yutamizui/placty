class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :events
  has_many :tickets
  has_many :points

  def translated_name
    if I18n.locale == :ja
      "#{ja_name}"
    elsif I18n.locale == :en
      "#{en_name}"
    end
  end
end
