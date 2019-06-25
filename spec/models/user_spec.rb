require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).with_foreign_key('author_id').inverse_of(:author) }
  it { should have_many(:answers).with_foreign_key('author_id').inverse_of(:author) }
  it { should have_many(:rewards) }
  it { should have_many(:authorizations).dependent(:destroy) }

  describe 'def author_of?' do
    let(:author) { create(:user) }
    let(:user) { create(:user) }
    let(:question) { create(:question, author: author) }

    it 'Returns true if question belongs to user' do
      expect(author).to be_author_of(question)
    end

    it 'Returns false if question does not belongs to user' do
      expect(user).to_not be_author_of(question)
    end
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
    let(:service) { double('Services::FindForOauth') }

    it 'calls Services::FindForOauth' do
      expect(Services::FindForOauth).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end
end
