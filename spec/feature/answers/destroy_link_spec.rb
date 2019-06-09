require 'rails_helper'

feature 'User can delete links from his answer' do
  given!(:author) { create(:user) }
  given!(:question) { create(:question, :with_link, author: author) }
  given!(:answer) { create(:answer, question: question, author: author) }
  given!(:link) { create(:link, linkable: answer) }

  scenario 'Unauthenticated user tries deleted link from answer', js: true do
    visit question_path(question)

    within '.answers .links-list' do
      expect(page).to_not have_link 'Delete link'
    end
  end

  describe 'Authenticated user' do
    scenario 'deleted link from his answer', js: true do
      sign_in(author)
      visit question_path(question)

      within '.answers .links-list' do
        expect(page).to have_link link.name, href: link.url
        click_on 'Delete link' 
        expect(page).to_not have_link link.name, href: link.url      
      end
    end

    scenario 'trying to delete a link from not his answer', js: true  do
      sign_in(create(:user))
      visit question_path(question)

      within '.answers .links-list' do
        expect(page).to_not have_link('Delete link')    
      end
    end
  end
end