require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:answer) { create(:answer, question: question, author: user) }


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
