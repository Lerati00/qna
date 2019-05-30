require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to(:question) }
  it { should belong_to(:author).class_name('User') }
  it { should have_many(:links).dependent(:destroy) }

  it { should accept_nested_attributes_for :links }

  it { should validate_presence_of :body }

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe 'def set_best' do
    let(:author) { create(:user) }
    let(:question) { create(:question, author: author) }
    let(:current_best_answer) { create(:answer, question: question, author: author) }
    let(:answer) { create(:answer, question: question, author: author)}

    before { answer.set_best }

    it 'the answer is the best' do
      expect(answer).to be_best
    end

    it 'there is only one best answer' do
      current_best_answer.set_best
      answer.reload
      
      expect(answer).to_not be_best
      expect(current_best_answer).to be_best
    end

  end
end
