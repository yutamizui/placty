class UsersController < ApplicationController
  
  def user_params
    params.require(:user).permit(:email, :ja_name, :en_name, :image)
  end
end
 