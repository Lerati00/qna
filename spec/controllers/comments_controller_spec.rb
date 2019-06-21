require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do
      it 'saves a new comment to the question in the database' do
        expect { 
          post :create, 
          params: { 
            question_id: question, 
            comment: attributes_for(:comment), 
            commentable: 'Question' 
          }, format: :js }.to change(question.comments, :count).by(1)
      end

      it 'renders create view' do
        post :create, params: { question_id: question, comment: attributes_for(:comment), commentable: 'question'}, format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'not saves a new comment in the database' do
        expect { 
          post :create, 
          params: { 
            question_id: question, 
            comment: attributes_for(:comment, :invalid), 
            commentable: 'Question' 
          }, format: :js }.to_not change(Comment, :count)
      end

      it 'renders create view' do
        post :create, params: { question_id: question, comment: attributes_for(:comment), commentable: 'question'}, format: :js
        expect(response).to render_template :create
      end
    end
  end

end
