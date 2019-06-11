require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I`d like to be able to edit my answer
} do

  given!(:author) { create(:user) }
  given!(:question) { create(:question, author: author) }
  given!(:answer) { create(:answer, question: question, author: author) }
  given(:gist_url) { 'https://gist.github.com/Lerati00/46f87d2c01b664f6c33955469894b40c' }

  scenario 'Unauthenticated user can not edit  answer' do 
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link('Edit')
    end
  end
  
  describe 'Authenticated user edits his answer' do
    background do
      sign_in(author)
      visit question_path(question)
    end
    
    scenario 'Edit answer', js: true do 
      within '.answers' do
        click_on 'Edit' 
        fill_in 'Your answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end 
    end

    scenario 'Edit answer with attached files', js: true do 
      within '.answers' do
        click_on 'Edit' 
        fill_in 'Your answer', with: 'edited answer'
        attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end 
    end

    scenario 'edit answer with attached link', js: true do
      within '.answers' do
        click_on 'Edit'
        fill_in 'Your answer', with: 'edited answer'
        click_on 'Add link'

        fill_in 'Link name', with: 'My gist'
        fill_in 'Url', with: gist_url

        click_on 'Save'
        expect(page).to have_link 'My gist', href: gist_url
        expect(page).to have_content 'My gists content'
      end
    end

    scenario 'with error', js: true do
      within '.answers' do
        click_on 'Edit' 
        fill_in 'Your answer', with: ''
        click_on 'Save'
        expect(page).to have_content "Body can't be blank"       
      end 
    end
  end
    
  scenario 'Authenticated user tries to edit other user`s answers' do
    sign_in(create(:user))
    visit question_path(question)
    
    within '.answers' do
      expect(page).to_not have_link('Edit')
    end
  end
end