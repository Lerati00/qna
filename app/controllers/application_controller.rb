class ApplicationController < ActionController::Base
  before_action :gon_user, unless: :devise_controller?

  check_authorization unless: :devise_controller?
  authorize_resource unless: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden, content_type: 'text/html' }
      format.html { redirect_to root_url, alert: exception.message }
      format.js   { head :forbidden, content_type: 'text/html' }
    end
  end

  private

  def gon_user
    gon.current_user_id = current_user.id if current_user
  end
end
