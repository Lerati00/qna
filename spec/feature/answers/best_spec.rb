require 'rails_helper'

feature 'The author of the question can choose the best answer to your question' do

  given!(:author) { create(:user) }
  given!(:question) { create(:question, author: author) }
  given!(:answer) { create(:answer, author: author, question: question) }
  scenario 'The author of the question chooses the best answer to your question', js: true do
    sign_in(author)
    visit question_path(question)

    within '.answers' do 
      click_on 'Make the best'
      expect(page).to have_content('Best')
    end
  end

  scenario 'Authenticated user tries choose the best answer for another question', js: true do
    sign_in(create(:user))
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Make the best'
    end
  end

  scenario 'Unauthenticated user tries choose the best answer', js: true do
    visit question_path(question)

    within '.answers' do 
      expect(page).to_not have_link 'Make the best' 
    end
  end
end