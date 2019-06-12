require 'rails_helper'

feature 'Authenticated user can vote for not his question' do

  given(:question) { create(:question) }
  given(:user) { create(:user) }
  given(:user_question) { create(:question, author: user) }

  scenario 'Unauthenticated user tries vote' do
    visit question_path(question)

    within '.question .rating' do
      expect(page).to_not have_link('Vote up')
    end
  end

  describe 'Authentecated user' do
    scenario 'tries vote for his question' do
      sign_in(user)
      visit question_path(user_question)

      within '.question .rating' do
        expect(page).to_not have_link('Vote up')
      end
    end

    describe 'for not his question' do
      background do 
        sign_in(user)
        visit question_path(question)
      end

      scenario 'vote up', js: true do
        within '.question .rating' do
          expect(page).to have_content 0
          click_on 'Vote up'
          expect(page).to have_content 1
        end
      end

      scenario 'vote down', js: true do
        within '.question .rating' do
          expect(page).to have_content 0
          click_on 'Vote down'
          expect(page).to have_content -1
        end
      end

      scenario 'cancel vote', js: true  do
        within '.question .rating' do
          click_on 'Vote up'
          expect(page).to have_content 1
          click_on 'Vote cancel'
          expect(page).to have_content 0
        end
      end
    end
  end
end
