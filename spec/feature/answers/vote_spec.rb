require 'rails_helper'

feature 'Authenticated user can vote for not his answer' do

  given(:question) { create(:question) }
  given(:user) { create(:user) }
  given!(:answer) { create(:answer, question: question) }
  given!(:user_answer) { create(:answer, question: question, author: user) }

  scenario 'Unauthenticated user tries vote' do
    visit question_path(question)
    answer

    within "#answer-#{answer.id} .rating" do
      expect(page).to_not have_link('Vote up')
    end
  end

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end
    
    scenario 'tries vote for his answer' do
      within "#answer-#{user_answer.id} .rating" do
        expect(page).to_not have_link('Vote up')
      end
    end

    context 'for not his answer' do
      scenario 'vote up', js: true do
        within "#answer-#{answer.id} .rating" do
          expect(page).to have_content 0
          click_on 'Vote up'
          expect(page).to have_content 1
        end
      end

      scenario 'vote down', js: true  do
        within "#answer-#{answer.id} .rating" do
          expect(page).to have_content 0
          click_on 'Vote down'
          expect(page).to have_content -1
        end
      end

      scenario 'cancel vote', js: true  do
        within "#answer-#{answer.id} .rating" do
          click_on 'Vote down'
          expect(page).to have_content -1
          click_on 'Vote cancel'
          expect(page).to have_content 0
        end
      end
    end
  end
end