class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]
  before_action :authenticate_user!

  # GET /resource/sign_up
  # def new
  #   super
  # end
  def create
    # ここでUser.new（と同等の操作）を行う
     build_resource(sign_up_params)
     resource.save

     # ブロックが与えられたらresource(=User)を呼ぶ
     yield resource if block_given?
  
     # 先程のresource.saveが成功していたら
     if resource.persisted?
       Note.create(
         title: "シェアノート",
         user_id: resource.id
       )
  
       # confirmable/lockableどちらかのactive_for_authentication?がtrueだったら
       if resource.active_for_authentication?
  
         set_flash_message! :notice, :signed_up
         # AdminActionMailer.new_registration_reminder(resource).deliver
         # UserActionMailer.user_registration_reminder(resource).deliver
  
         sign_up(resource_name, resource)
         respond_with resource, location: after_sign_up_path_for(resource)
  
       else
         set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
         expire_data_after_sign_in!
         respond_with resource, location: after_inactive_sign_up_path_for(resource)
       end
     else
       clean_up_passwords resource
       set_minimum_password_length
       respond_with resource
     end
   end
  # GET /resource/edit
  # def edit
  #   super
  # end

  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    # resource.login_name = params[:user][:login_name]

    resource_updated = resource.update_without_current_password(account_update_params)
    
   
    yield resource if block_given?
    if resource_updated
      if is_flashing_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
          :update_needs_confirmation : :updated
        set_flash_message :notice, flash_key
      end
      bypass_sign_in resource, scope: resource_name
      # respond_with resource, location: after_update_path_for(resource)
      redirect_to edit_user_registration_path, method: :put
    else
      clean_up_passwords resource
      set_minimum_password_length
      # respond_with resource
      render 'users/registrations/edit'
    end
  end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

  protected
  def update_resource(resource, params)
    resource.update_without_current_password(params)
  end

  # def after_update_path_for(resource)
  #   user_path(@user.id)
  # end
end
