require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I`d like to be anble edit mu question
} do 

  given!(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }

  scenario 'Unathenticated user can`t edit question' do
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_link('Edit')
    end
  end

  describe 'Authenticated user edits his question' do 
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'edit question', js: true do
      within '.question' do
        click_on 'Edit'
        fill_in 'Your question', with: 'edited quetion'
        fill_in 'Title', with: 'edited quetion'
        click_on 'Save'

        expect(page).to_not have_content question.body
        expect(page).to have_content 'edited quetion'
        expect(page).to_not have_selector 'edit-question'
      end
    end

    scenario 'with error', js: true do
      within '.question' do
        click_on 'Edit'
        fill_in 'Title', with: ''
        click_on 'Save'
      end

      expect(page).to have_content "Title can't be blank"
    end
  end

  scenario 'tries to edit other user`s question' do
    sign_in(create(:user))
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_link 'Edit'
    end
  end
  

end
