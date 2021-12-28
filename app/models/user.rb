class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :events, dependent: :destroy
  has_many :tickets, dependent: :destroy
  has_many :points, dependent: :destroy

  def update_without_current_password(params, *options)

    ## current_password のパラメータを削除。
    params.delete(:current_password)

    ## パスワード変更のためのパスワード入力フィールドとその確認フィールドの両者とも空の場合のみ、パスワードなしで更新できるようにするためです。
    if params[:password].blank? && params[:password_confirmation].blank?

      params.delete(:password)
      params.delete(:password_confirmation)
    end

    result = update(params, *options)
    clean_up_passwords
    result
  end

  def translated_name
    if I18n.locale == :ja
      "#{ja_name}"
    elsif I18n.locale == :en
      "#{en_name}"
    end
  end
end
