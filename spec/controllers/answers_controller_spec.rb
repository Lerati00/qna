require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }


  describe 'POST #create' do
    before { sign_in(user) }
    
    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { 
          post :create, 
          params: { 
            question_id: question, 
            answer: attributes_for(:answer) 
          } 
        }.to change(question.answers, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { 
          post :create, 
          params: { 
            question_id: question, 
            answer: attributes_for(:answer, :invalid) 
          } 
        }.to_not change(question.answers, :count)
      end

      it 're-renders new view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'DELETE #destroy' do
    before { sign_in(user) }

    let!(:answer) { create(:answer, question: question, author: user) }

    context 'User tries to delete his answer' do
      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
      end

      it 'redirects to questions/show view' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'User tries to delete not his answer' do 
      before { sign_in(create(:user)) }

      it 'does not delete the answer' do
        expect { delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
      end

      it 'have 403 staus' do
        delete :destroy, params: { id: answer }
        expect(response).to have_http_status(403) 
      end
    end
  end
end
