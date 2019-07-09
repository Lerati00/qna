# Preview all emails at http://localhost:3000/rails/mailers/subscription
class SubscriptionPreview < ActionMailer::Preview
  def send_answer
    SubscriptionMailer.send_answer(Answer.first, User.first)
  end
end
