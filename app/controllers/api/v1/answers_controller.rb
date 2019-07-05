class Api::V1::AnswersController < Api::V1::BaseController
  expose(:question)
  expose(:answer)

  def index
    @answers = question.answers
    render json: @answers, each_serializer: AnswersSerializer
  end

  def show
    render json: answer
  end
end