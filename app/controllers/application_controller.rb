class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?
  protect_from_forgery with: :null_session
  

  def locale
    if ["ja", "en"].include?(params[:locale])
      cookies[:locale] = params[:locale]
      redirect_to :root
    end
  end

  def set_locale
    if ["ja", "en"].include?(cookies[:locale])
      I18n.locale = cookies[:locale]
    end
  end
  

  def after_sign_in_path_for(resource)
    events_path # ログイン後に遷移するpathを設定
  end

  def after_sign_out_path_for(resource)
    events_path # ログアウト後に遷移するpathを設定
  end

  protected

  def configure_permitted_parameters
    added_attrs = [ :email, :ja_name, :en_name, :password, :password_confirmation, [:image], :time_zone_id ]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
    devise_parameter_sanitizer.permit :sign_in, keys: added_attrs
  end
end
