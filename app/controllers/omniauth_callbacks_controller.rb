class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :require_no_authentication
  class << self
    def provides_callback_for provider
      class_eval %Q{
        def #{provider}
          @user = User.find_for_oauth env["omniauth.auth"], current_user

          if @user.persisted?
            sign_in_and_redirect @user, event: :authentication
            set_flash_message(:notice,
              :success, kind: "#{provider}".capitalize) if is_navigational_format?
          else
            session["devise.#{provider}_data"] = env["omniauth.auth"]
            redirect_to new_user_registration_path
          end
        end
      }
    end
  end


  [:twitter, :facebook].each do |provider|
    provides_callback_for provider
  end

  def after_sign_in_path_for resource
    if resource.email_verified?
      super resource
    else
      user_path(resource)
    end
  end
end
