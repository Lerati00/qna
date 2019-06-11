require 'rails_helper'

shared_examples_for 'votable' do
  let(:model) { described_class }
  let(:object) { create(model.to_s.underscore.to_sym)}
  let(:user) { create(:user) }

  it '#score' do
    object.votes.create(user: user)

    expect(object.score).to eq 1
  end

  describe '#voted?' do
    it 'return true if user vote' do
      object.votes.create(user: user)

      expect(object.voted?(user)).to eq true
    end

    it 'return false if user not vote' do
      expect(object.voted?(user)).to eq false
    end
  end

  describe '#vote' do
    it 'with type true' do
      expect { object.vote(user, true) }.to change(Vote, :count).by(1)
      expect(object.votes.last.score).to eq 1
    end

    it 'with type false' do
      expect { object.vote(user, false) }.to change(Vote, :count).by(1)
      expect(object.votes.last.score).to eq -1
    end
  end 

  it '#cancel_vote' do
    object.vote(user, true)
    expect { object.cancel_vote(user) }.to change(Vote, :count).by(-1)
  end
end