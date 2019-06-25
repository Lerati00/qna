class OauthCallbacksController < Devise::OmniauthCallbacksController
  def oauth_provider
    auth = request.env['omniauth.auth']
    @user = User.find_for_oauth(auth)

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: auth.provider.capitalize) if is_navigational_format?
    else
      session['devise.oauth_uid'] = auth.uid
      session['devise.oauth_provider'] = auth.provider
      redirect_to users_add_email_path
    end
  end

  alias_method :github, :oauth_provider
  alias_method :facebook, :oauth_provider
end
