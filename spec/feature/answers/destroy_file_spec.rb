require 'rails_helper'

feature 'User can delete files from his answer' do
  given!(:author) { create(:user) }
  given!(:question) { create(:question, author: author) }
  given!(:answer) { create(:answer, :with_file, question: question, author: author) }
  given(:user) { create(:user) }

  scenario 'Unauthenticated user tries deleted file from answer' do
    visit question_path(question)

    within '.answers .files' do
      expect(page).to_not have_link 'Delete'
    end
  end

  describe 'Authenticated user' do
    scenario 'deleted file from his answer', js: true do 
      sign_in(author)
      visit question_path(question)

      filename = answer.files.first.filename.to_s
      within '.answers .files' do
        expect(page).to have_content(filename)
        click_on 'Delete' 
        expect(page).to_not have_content(filename)      
      end  
    end

    scenario 'trying to delete a file from not his answer' do
      sign_in(user)
      visit question_path(question)

      within '.answers .files' do
        expect(page).to_not have_link('Delete')    
      end
    end
  end
end