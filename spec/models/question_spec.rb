require 'rails_helper'
require_relative 'concerns/votable_spec'
require_relative 'concerns/subscribable_spec'

RSpec.describe Question, type: :model do
  it { should belong_to(:author).class_name('User') }
  
  it { should have_one(:reward).dependent(:destroy) }

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy)}
  it { should have_many(:subscribers) }

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :reward }

  it_behaves_like "votable"
  it_behaves_like "subscribable"


  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe 'reputation' do
    let(:question) { build(:question) }

    it 'calls ReputationJob#perform_later' do
      expect(ReputationJob).to receive(:perform_later).with(question)
      question.save!
    end
  end
end
