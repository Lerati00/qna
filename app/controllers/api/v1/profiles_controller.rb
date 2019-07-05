class Api::V1::ProfilesController < Api::V1::BaseController
  def me
    render json: current_resource_onwer
  end

  def index
    @users = User.all.where('id != ?', current_resource_onwer.id)
    render json: @users
  end
end