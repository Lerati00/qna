require 'rails_helper'

feature 'User can create answer', %q{
  The user, being on the question page, can write an answer to the question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user)}

  describe 'In multiple sessions', js: true do
    scenario 'Answer appears on another browser' do
      Capybara.using_session('user') do
        sign_in user
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Your answer', with: 'Answer Body Text'

        click_on 'Create'   
        within '.answers' do
          expect(page).to have_content 'Answer Body Text'
        end  
      end

      Capybara.using_session('guest') do
        within '.answers' do
          expect(page).to have_content 'Answer Body Text'
        end
      end
    end
  end
 
  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'write an answer', js: true  do
      fill_in 'Your answer', with: 'Answer Body Text'
      click_on 'Create'

      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_content 'Answer Body Text'
      end
    end

    scenario 'write an answer with attached files', js: true  do
      fill_in 'Your answer', with: 'Answer Body Text'
      attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Create'

      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_content 'Answer Body Text'
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'write an answer with errors', js: true do
      click_on 'Create'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to write an answer' do
    visit question_path(question)
    expect(page).to_not have_link 'Create'
  end

end