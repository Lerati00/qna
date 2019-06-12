module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: %i[vote_up vote_down vote_cancel]
  end

  def vote_up
    @votable.vote(current_user, true) unless current_user.author_of?(@votable)
    make_response
  end

  def vote_down
    @votable.vote(current_user, false) unless current_user.author_of?(@votable)
    make_response
  end

  def vote_cancel
    @votable.cancel_vote(current_user) unless current_user.author_of?(@votable)
    make_response
  end

  private

  def make_response
    respond_to do |format|
      format.json { render_json(@votable) }
    end
  end

  def render_json(item)
    body = { "id": item.id, "score": item.score }
    render json: Hash[param_name(item), body]
  end

  def param_name(item)
    item.class.name.underscore
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end
end
