require 'rails_helper'

feature 'User can delete files from his question' do
  given!(:author) { create(:user) }
  given!(:question) { create(:question, :with_file, author: author) }
  given(:user) { create(:user) }

  scenario 'Unauthenticated user tries deleted file from question' do
    visit question_path(question)

    within '.files' do
      expect(page).to_not have_link 'Delete'
    end
  end

  describe 'Authenticated user' do
    scenario 'deleted file from his question', js: true do
      sign_in(author)
      visit question_path(question)

      filename = question.files.first.filename.to_s
      within '.files' do
        expect(page).to have_content(filename)
        click_on 'Delete' 
        expect(page).to_not have_content(filename)      
      end    
    end

    scenario 'trying to delete a file from not his question' do
      sign_in(user)
      visit question_path(question)
      within '.files' do
        expect(page).to_not have_link('Delete')    
      end
    end
  end
end