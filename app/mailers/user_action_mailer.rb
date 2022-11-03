class UserActionMailer < ApplicationMailer
  default :from => 'info@placty.com'

  # send a signup email to the user, pass in the user object that   contains the user's email address
  def note_creation_notifier(note)
    @note =  note
    mail(
      :to => "info@placty.com",
      :subject => @note.title,
    )
  end
end