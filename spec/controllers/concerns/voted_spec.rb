require 'rails_helper'

shared_examples_for 'voted' do
  let(:object) { create(controller.controller_name.classify.downcase.to_sym) }
  let(:user) { create(:user) }

  before do
    login user
  end

  describe 'PATCH #vote_up' do
    it 'change rating up' do
      expect { patch :vote_up, params: { id: object }, format: :json }.to change(object.votes, :count).to(1)
    end
  end

  describe 'PATCH #vote_down' do
    it 'change rating down' do
      expect { patch :vote_down, params: { id: object }, format: :json }.to change(object.votes, :count).to(1)
    end
  end

  describe 'PATCH #vote_cancel' do
    before do
      patch :vote_down, params: { id: object }, format: :json
    end

    it 'cancel voting' do
      expect { delete :vote_cancel, params: { id: object }, format: :json }.to change(object.votes, :count).by(-1)
    end
  end
end