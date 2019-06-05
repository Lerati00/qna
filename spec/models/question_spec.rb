require 'rails_helper'

RSpec.describe Question, type: :model do
  it {should belong_to(:author).class_name('User') }
  
  it { should have_one(:reward).dependent(:destroy) }

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :reward }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe 'def reward?' do
    let(:author) { create(:user) }
    let(:question) { create(:question, :with_reward, author: author) }
    let(:question_not_reward) { create(:question,  author: author) }

    it 'true if question have reward' do
      expect(question).to be_reward
    end

    it 'false if question not have reward' do
      expect(question_not_reward).to_not be_reward
    end
  end
end
