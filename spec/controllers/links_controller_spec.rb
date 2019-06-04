require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  let(:answer) { create(:answer, question: question, author: user) }

  describe 'DELETE #destroy' do
    before { login(user) }

    let!(:link_question) { create(:link, linkable: question) }
    let!(:link_answer) { create(:link, linkable: answer) }

    context 'User tries to delete link on his resource' do
      it 'deletes the link on his question' do
        expect { delete :destroy, params: { id: link_question }, format: :js }.to change(question.links, :count).by(-1)
      end

      it 'deletes the link on his answer' do
        expect { delete :destroy, params: { id: link_answer }, format: :js }.to change(answer.links, :count).by(-1)
      end
    end

    context 'User tries to delete link to another resource' do
      before { sign_in(create(:user)) }

      let!(:link_question) { create(:link, linkable: question) }
      let!(:link_answer) { create(:link, linkable: answer) }

      it 'does not delete link on another question' do
        expect { delete :destroy, params: { id: link_question }, format: :js }.to_not change(question.links, :count)
      end

      it 'does not delete link on another answer' do
        expect { delete :destroy, params: { id: link_answer }, format: :js }.to_not change(answer.links, :count)
      end
    end
  end
end
