require 'rails_helper'

RSpec.describe RegistrationSupplementsController, type: :controller do
  describe 'Post #create_authorization' do
    context 'if user exists' do
      let!(:confirmed_user) { create(:user, :with_auth, :confirmed) }
      let!(:unconfirmed_user) { create(:user) }

      context 'user confirmed' do
        it 'signs in' do
          patch :create_authorization, params: { user: { email: confirmed_user.email } }
          expect(controller.current_user).to eq confirmed_user
        end

        it 'redirects to root_path' do
          patch :create_authorization, params: { user: { email: confirmed_user.email } }

          expect(response).to redirect_to root_path
        end
      end

      context 'user does not confirmed' do
        it 'redirects to root_path' do
          patch :create_authorization, params: { user: { email: unconfirmed_user.email } }

          expect(response).to redirect_to root_path
        end
      end
    end

    context 'if user does not exissts' do
      let(:email) { 'prostoEmail@gmail.com' }
      
      it 'Creates new user' do
        expect { patch :create_authorization, params: { user: { email: email } } }.to change(User, :count).by(1)
      end

      it 'sends confirmation email' do
        expect_any_instance_of(User).to receive(:send_confirmation_instructions)

        patch :create_authorization, params: { user: { email: email } }
      end
    end
  end
end
