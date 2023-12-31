class User < ApplicationRecord
  mount_uploader :image, ImageUploader
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :events, dependent: :destroy
  has_many :tickets, dependent: :destroy
  has_many :points, dependent: :destroy
  has_many :invoices, dependent: :destroy
  has_many :notice_boards, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_many :reports, dependent: :destroy
  has_one :bank_account


  validates :time_zone_id, presence: true

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

  

end
