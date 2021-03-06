class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  before_action :load_question, only: :create
  before_action :load_answer, only: %i[update best]

  after_action :publish_answer, only: %i[create]

  def create
    if user_signed_in?
      @answer = @question.answers.new(answer_params)
      @answer.author = current_user
      @answer.save
    end
  end

  def update
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
      @question = @answer.question
    end
  end

  def best
    @question = @answer.question
    @answer.set_best if current_user.author_of?(@question)
  end

  def destroy
    @answer = Answer.find(params[:id])
    @answer.destroy if current_user.author_of?(@answer)
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(
      :body,
      files: [],
      links_attributes: %i[id name url _destroy]
    )
  end

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast(
      "question_#{@answer.question.id}",
      ApplicationController.render(
        partial: 'answers/answer_channel',
        locals: { answer: @answer }
      )
    )
  end
end
