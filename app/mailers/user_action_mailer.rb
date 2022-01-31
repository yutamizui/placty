class UserActionMailer < ApplicationMailer
    default :from => 'info@calahe-navi.com'

    # send a signup email to the user, pass in the user object that   contains the user's email address
    def send_user_booking_notifier(user, lesson)
      @user = user
      @lesson = lesson
      mail( :to => @user.email,
      :subject => 'ご体験レッスンお申し込完了のお知らせ' )
    end
  end