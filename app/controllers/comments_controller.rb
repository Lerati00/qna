class CommentsController < ApplicationController
  before_action :set_commentable, only: %i[create]
  after_action :publish_comment, only: %i[create]

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    @comment.save
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_commentable
    commentable_id = params["#{params[:commentable].downcase}_id"]
    @commentable = params[:commentable].classify.constantize.find(commentable_id)
  end

  def publish_comment
    return if @comment.errors.any?

    resource = @comment.commentable
    question_id = resource.is_a?(Question) ? resource.id : resource.question.id
    
    ActionCable.server.broadcast(
      "comments_question_#{question_id}",
      ApplicationController.render(
        partial: 'comments/comment_channel',
        locals: { comment: @comment }
      )
    )
  end
end
