class UserActionMailer < ApplicationMailer
    default :from => 'info@calahe.com'

    # send a signup email to the user, pass in the user object that   contains the user's email address
    def inquiry_mail(name, email, title, content)
      @name = name
      @email = email
      @title = title
      @content = content
      mail( 
        :to => "info@calahe.com",
        :from => @email,
        :subject => @title,
        :name => @name,
        :content => @content
      )
    end
  end