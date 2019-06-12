require 'rails_helper'
require_relative 'concerns/voted_spec'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:answer) { create(:answer, question: question, author: user) }

  it_behaves_like "voted"

  describe 'POST #create' do
    before { login(user) }
    
    context 'with valid attributes' do
      it 'saves a new answer in the database' do
        expect { 
          post :create, 
             params: { question_id: question, author_id: user, answer: attributes_for(:answer) },
             format: :js
        }.to change(question.answers, :count).by(1)
      end

      it "saves a new user`s answer in the database" do
        expect { 
          post :create, 
             params: { question_id: question, author_id: user, answer: attributes_for(:answer) },
             format: :js
        }.to change(user.answers, :count).by(1)
      end

      it 'renders create view' do
        post :create, 
             params: { question_id: question, author_id: user, answer: attributes_for(:answer) },
             format: :js
        expect(response).to render_template 'create'
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { 
          post :create, 
          params: { 
            question_id: question, 
            answer: attributes_for(:answer, :invalid) 
          },
          format: :js
        }.to_not change(Answer, :count)
      end

      it 'renders create view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template 'create'
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }
    
    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'render update view' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not changes answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(answer, :body)
      end

      it 'render update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }

    let!(:answer) { create(:answer, question: question, author: user) }

    context 'User tries to delete his answer' do
      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'renders destroy view' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'User tries to delete not his answer' do 
      before { sign_in(create(:user)) }

      it 'does not delete the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to_not change(Answer, :count)
      end

      it 'renders destroy view' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
      end
    end
  end

  describe 'PATCH #best' do
    context 'User set best answer to his question' do
      before { sign_in(user) }
  
      it 'choose the answer as the best' do
        patch :best, params: { id: answer }, format: :js
        answer.reload
        expect(answer).to be_best
      end

      it 'renders best view' do
        patch :best, params: { id: answer }, format: :js
        expect(response).to render_template :best
      end
    end
    
    context "The user asks the best answer to someone else's question" do
      before { sign_in(create(:user)) }
  
      it 'tries choose the answer as the best' do
        patch :best, params: { id: answer }, format: :js
        answer.reload
        expect(answer).to_not be_best
      end

      it 'renders best view' do
        patch :best, params: { id: answer }, format: :js
        expect(response).to render_template :best
      end
    end
  end
end
