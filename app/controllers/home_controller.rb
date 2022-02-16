class HomeController < ApplicationController

  def index
  end

  def contact
  end

  def contact_sending
    if current_user.present?
      @name = current_user.translated_name
      @email = current_user.email
    else
      @name = params[:name]
      @email = params[:email]
    end
    @title = params[:title]
    @content = params[:content]
    UserActionMailer.inquiry_mail(@name, @email, @title, @content).deliver

    redirect_to contact_path, notice: t('activerecord.attributes.contact.sent_successfully')
  end

  def introduction
  end
end
