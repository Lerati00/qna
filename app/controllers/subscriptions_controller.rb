class SubscriptionsController < ApplicationController
  def create
    @question =  Question.find(params[:question_id])
    @question.subscribe(current_user)
    render :subscribe
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    @question = @subscription.subscribable
    @subscription.destroy
    
    render :subscribe
  end
end
