class Api::V1::ProfilesController < Api::V1::BaseController
  skip_authorize_resource 

  def me
    render json: current_resource_onwer
    authorize! :read, current_resource_onwer
  end

  def index
    @users = User.all.where.not(id: current_resource_onwer)
    render json: @users
    authorize! :read, @users
  end
end