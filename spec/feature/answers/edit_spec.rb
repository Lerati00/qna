require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I`d like to be able to edit my answer
} do

  given!(:author) { create(:user) }
  given!(:question) { create(:question, author: author) }
  given!(:answer) { create(:answer, question: question, author: author) }

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