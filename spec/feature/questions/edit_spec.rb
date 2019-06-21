require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I`d like to be anble edit mu question
} do 

  given!(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given(:gist_url) { 'https://gist.github.com/Lerati00/46f87d2c01b664f6c33955469894b40c' }

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

    scenario 'edit question with attached files', js: true do
      within '.question' do
        click_on 'Edit'
        fill_in 'Your question', with: 'edited quetion'
        fill_in 'Title', with: 'edited quetion'
        attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'edit question with attached link', js: true do
      within '.question' do
        click_on 'Edit'
        fill_in 'Your question', with: 'edited quetion'
        fill_in 'Title', with: 'edited quetion'

        click_on 'Add link'

        fill_in 'Link name', with: 'My gist'
        fill_in 'Url', with: gist_url

        click_on 'Save'

        expect(page).to have_link 'My gist'
      end
    end

    scenario 'with errors', js: true do
      within '.question' do
        click_on 'Edit'
        fill_in 'Title', with: ''
        click_on 'Save'
      end

      expect(page).to have_content "Title can't be blank"
    end
  end

  scenario 'Authenticated user tries to edit other user`s question' do
    sign_in(create(:user))
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_link 'Edit'
    end
  end
  

end
