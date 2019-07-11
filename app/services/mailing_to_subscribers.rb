class Services::MailingToSubscribers
  def send_emails(answer)
    answer.question.subscribers.each do |subscriber|
      SubscriptionMailer.send_answer(answer, subscriber).deliver_later
    end
  end
end
