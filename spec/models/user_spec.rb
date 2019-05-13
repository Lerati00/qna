require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).with_foreign_key('author_id').inverse_of(:author) }
  it { should have_many(:answers).with_foreign_key('author_id').inverse_of(:author) }

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
end
