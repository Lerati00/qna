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

  def create
    answer = question.answers.new(answer_params)
    answer.author = current_resource_onwer
    if answer.save
      render json: answer
    else
      head 422
    end
  rescue ActionController::ParameterMissing
    head :bad_request
  end

  def update
    if answer.update(answer_params)
      render json: answer
    else
      head 422
    end
  rescue ActionController::ParameterMissing
    head :bad_request
  end

  def destroy
    head :ok if answer.destroy
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
