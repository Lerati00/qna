class Api::V1::BaseController < ActionController::Base
  before_action :doorkeeper_authorize!
  protect_from_forgery prepend: true

  rescue_from CanCan::AccessDenied do |exception|
    head :bad_request
  end

  private

  def current_resource_onwer
    @current_resource_onwer ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  def current_ability
    @current_ability ||= Ability.new(current_resource_onwer)
  end
end