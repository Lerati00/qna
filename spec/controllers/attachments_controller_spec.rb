require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  describe 'DELETE #destroy' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, :with_file, author: user)}
    let!(:answer) { create(:answer, :with_file, question: question, author: user)}

    context 'Authenticated user ' do
      context 'as author question' do
        before { login(question.author) }

        it 'tries to deletes question' do
          expect { delete :destroy, params: { id: question.files.first }, format: :js }.to change(question.files, :count).by(-1)
        end

        it 'renders destroy view' do
          delete :destroy, params: { id: question.files.first }, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'as not author question' do
        before { login(create(:user)) }
        
        it 'tries to deletes nit his question' do
          expect { delete :destroy, params: { id: question.files.first }, format: :js }.to_not change(question.files, :count)
        end

        it 'renders destroy view' do
          delete :destroy, params: { id: question.files.first }, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'as author answer' do
        before { login(question.author) }

        it 'tries to deletes question' do
          expect { delete :destroy, params: { id: answer.files.first }, format: :js }.to change(answer.files, :count).by(-1)
        end

        it 'renders destroy view' do
          delete :destroy, params: { id: answer.files.first }, format: :js
          expect(response).to render_template :destroy
        end
      end

      context 'as not author question' do
        before { login(create(:user)) }
        
        it 'tries to deletes nit his question' do
          expect { delete :destroy, params: { id: answer.files.first }, format: :js }.to_not change(answer.files, :count)
        end

        it 'renders destroy view' do
          delete :destroy, params: { id: answer.files.first }, format: :js
          expect(response).to render_template :destroy
        end
      end
    end
    
    it 'Unauthenticated user' do
      delete :destroy, params: { id: question.files.first }
      expect(response).to redirect_to new_user_session_path
    end 
  end
end
