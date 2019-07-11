class MailingToSubscribersJob < ApplicationJob
  queue_as :default

  def perform(answer)
    Services::MailingToSubscribers.new.send_emails(answer)
  end
end
