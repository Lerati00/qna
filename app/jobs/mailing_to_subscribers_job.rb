class MailingToSubscribersJob < ApplicationJob
  queue_as :default

  def perform(answer)
    Services::MailingToSubscribers.new.send_answer(answer)
  end
end
