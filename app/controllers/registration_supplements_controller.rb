class RegistrationSupplementsController < ApplicationController
  skip_authorization_check
  skip_authorize_resource

  def add_email; end

  def create_authorization
    auth = OmniAuth::AuthHash.new(provider: session['devise.oauth_provider'],
                                  uid: session['devise.oauth_uid'],
                                  info: { email: params[:user][:email] })
    @user = User.find_for_oauth(auth)

    if @user&.persisted?
      if @user.confirmed?
        sign_in_and_redirect @user, event: :authentication
      else
        redirect_to root_path
      end
    else
      redirect_to root_path
    end
  end
end
