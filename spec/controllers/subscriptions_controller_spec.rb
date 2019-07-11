require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }

  before do
    login user
  end

  describe 'POST #create' do
    let(:question) { create(:question) }

    it "it adds subscriber" do
      expect { post :create, params: { question_id: question.id } }.to change(question.subscribers, :count).by(1)
    end

    it "it adds subscriptions to user" do
      expect { post :create, params: { question_id: question.id } }.to change(user.subscriptions, :count).by(1)
    end

    it 'redirect to question path' do
      post :create, params: { question_id: question.id }
      expect(response).to redirect_to(question_path(question))
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question) }
    let!(:subscription) { create(:subscription, subscribable: question, user: user) }

    it "it deletes subscriber" do
      expect { delete :destroy, params: { id: subscription.id } }.to change(question.subscribers, :count).by(-1)
    end

    it "it deletes subscription to user" do
      expect { delete :destroy, params: { id: subscription.id } }.to change(user.subscriptions, :count).by(-1)
    end

    it 'redirect to question path' do
      delete :destroy, params: { id: subscription.id }
      expect(response).to redirect_to(question_path(question))
    end
  end
end
