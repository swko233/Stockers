# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    build_resource(sign_up_params)

    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      #追加部分
      ##バリデーションエラーをフォームに出力するための変数
      ##email_errmsgの中身は書き換えずに、ビューファイルにエラーメッセージを記述
      @email_errmsg = resource.errors.full_messages_for(:email)
      if @email_errmsg[0] == "Eメール translation missing: ja.activerecord.errors.models.user.attributes.email.taken"
        @email_exist_flag = true
      end
      @name_errmsg = resource.errors.full_messages_for(:name)
      @nickname_errmsg = resource.errors.full_messages_for(:nickname)
      @password_errmsg = resource.errors.full_messages_for(:password)
      if @password_errmsg[0] == "パスワード translation missing: ja.activerecord.errors.models.user.attributes.password.too_short"
        @password_short_flag = true
      elsif @password_errmsg[0] == "パスワード translation missing: ja.activerecord.errors.models.user.attributes.password.too_long"
        @password_long_flag = true
      end
      @password_confirmation_errmsg = resource.errors.full_messages_for(:password_confirmation)
      #追加ここまで

      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

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

  #protected

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
end
