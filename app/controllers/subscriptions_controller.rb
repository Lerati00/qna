class SubscriptionsController < ApplicationController
  def create
    @question=  Question.find(params[:question_id])
    @question.subscriptions.create(user: current_user)
    redirect_to question_path(@question), notice: 'You have subscribed to the question'
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    @question = @subscription.subscribable
    @subscription.destroy
    
    redirect_to question_path(@question), notice: 'You have unsubscribed from the question'
  end
end
