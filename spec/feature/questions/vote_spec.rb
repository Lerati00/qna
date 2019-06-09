require 'rails_helper'

feature 'User can vote for question', %q{
  To find out which question is better
} do

  given(:user) { create(:user) }
  given(:question_with_author) { create(:question, author: user) }
  given(:question) { create(:question) }

  scenario 'Unauthenticated user tries vote' do
    visit question_path(question)

    within ".question .rating" do
      expect(page).to_not have_link('Vote up')
    end
  end
  describe 'Authenticated user' do

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'tries vote for his question' do
      visit question_path(question_with_author)
      within ".question .rating" do
        expect(page).to_not have_link('Vote up')
      end
    end


    scenario 'votes for not his question' do      
      within ".question .rating" do
        expect(page).to have_content 0
        click_on 'Vote up'
        expect(page).to have_content 1
      end
    end
  end 
end
