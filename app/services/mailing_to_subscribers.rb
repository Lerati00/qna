class Services::MailingToSubscribers
  def send_answer(answer)
    answer.question.subscribers.each do |subscriber|
      SubscriptionMailer.new.send_answer(answer, subscriber).deliver_later
    end
  end
end
