require 'rails_helper'

shared_examples_for 'subscribable' do
  let(:model) { described_class }
  let(:object) { create(model.to_s.underscore.to_sym)}
  let(:user) { create(:user) }

  describe '#subscribed?' do
    it 'returns true if user already subscribed' do
      object.subscriptions.create(user: user)

      expect(object.subscribed?(user)).to eq true
    end

    it 'returns false if user is not subscribed' do
      expect(object.subscribed?(user)).to eq false
    end
  end

  describe '#subscribe' do
    it 'creates subscription if user is not subscribed' do
      expect{ object.subscribe(user) }.to change(Subscription, :count).by(1)
    end

    it 'not creates subscription if user is subscribed' do
      object.subscribe(user)
      expect{ object.subscribe(user) }.to_not change(Subscription, :count)
    end
  end
end