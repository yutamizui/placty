class UsersController < ApplicationController
  before_action :authenticate_user!
  
  def user_params
    params.require(:user).permit(:email, :ja_name, :en_name, :image)
  end
end
 