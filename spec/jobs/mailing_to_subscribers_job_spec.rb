require 'rails_helper'

RSpec.describe MailingToSubscribersJob, type: :job do
  let(:service) { double('Services::NotifySubscribers') }
  let(:subscription) { create(:subscription, :for_question) }
  let(:answer) { create(:answer, question: subscription.subscribable) }

  before do
    allow(Services::MailingToSubscribers).to receive(:new).and_return(service)
  end

  it 'calls Services::NotifySubscribers#send_emails' do
    expect(service).to receive(:send_emails).with(answer)
    MailingToSubscribersJob.perform_now(answer)
  end
end
