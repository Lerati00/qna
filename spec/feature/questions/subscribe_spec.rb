require 'rails_helper'

feature 'User can subscribe on question' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Unathenticated user' do
    background { visit question_path(question)}

    scenario 'tries subscribe to a question' do
      expect(page).to_not have_link 'Subscribe'
    end

    scenario 'tries unsubscribe from the question' do
      expect(page).to_not have_link 'Unsubscribe'
    end
  end

  describe 'Authenticated user' do
    context 'not have signed on question' do
      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'subscribe to a question' do
        click_on 'Subscribe'
        expect(page).to have_content 'You have subscribed to the question'
      end

      scenario 'tries unsubscribe from the question' do
        expect(page).to_not have_link 'Unsubscribe'
      end
    end

    context 'have signed on question' do
      background do
        question.subscriptions.create(user: user)
        sign_in(user)
        visit question_path(question)
      end

      scenario 'Unsubscribe from a the question' do
        click_on 'Unsubscribe'
        expect(page).to have_content 'You have unsubscribed from the question'
      end

      scenario 'tries subscribe to a question' do
        expect(page).to_not have_link 'Subscribe'
      end
    end
  end
end