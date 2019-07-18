require 'rails_helper'

RSpec.describe Services::Search do
  describe '#result' do
    let(:params) {  { search_string: '', search_type: '' } }
    subject { Services::Search.new(params) }

    context 'search in all records' do
      it 'return all records' do
        expect(ThinkingSphinx).to receive(:search).with('', { classes: nil })
        subject.result
      end

      it 'return al with search string' do
        params[:search_string] = 'new string'
        expect(ThinkingSphinx).to receive(:search).with('new string', { classes: nil })
        subject.result
      end
    end

    context 'search in all questions' do
      before { params[:search_type] = 'question' }

      it 'return all questions' do
        expect(ThinkingSphinx).to receive(:search).with('', { classes: [Question] })
        subject.result
      end

      it 'return questions with search string' do
        params[:search_string] = 'new string'
        expect(ThinkingSphinx).to receive(:search).with('new string', { classes: [Question] })
        subject.result
      end
    end

    context 'search in all answers' do
      before { params[:search_type] = 'answer' }

      it 'return all answers' do
        expect(ThinkingSphinx).to receive(:search).with('', { classes: [Answer] })
        subject.result
      end

      it 'return answers with search string' do
        params[:search_string] = 'new string'
        expect(ThinkingSphinx).to receive(:search).with('new string', { classes: [Answer] })
        subject.result
      end
    end

    context 'search in all comments' do
      before { params[:search_type] = 'comment' }

      it 'return all comments' do
        expect(ThinkingSphinx).to receive(:search).with('', { classes: [Comment] })
        subject.result
      end

      it 'return comments with search string' do
        params[:search_string] = 'new string'
        expect(ThinkingSphinx).to receive(:search).with('new string', { classes: [Comment] })
        subject.result
      end
    end

    context 'search in all users' do
      before { params[:search_type] = 'user' }

      it 'return all users' do
        expect(ThinkingSphinx).to receive(:search).with('', { classes: [User] })
        subject.result
      end

      it 'return users with search string' do
        params[:search_string] = 'new string'
        expect(ThinkingSphinx).to receive(:search).with('new string', { classes: [User] })
        subject.result
      end
    end

  end
end