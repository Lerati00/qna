require 'rails_helper'

feature 'Author can delete his answer' do
  given(:author) { create(:user) }
  given(:question) { create(:question, author: author) }
  given!(:answer) { create(:answer, author: author, question: question) }

  describe 'Authenticated user tries' do
    scenario 'deletes his answer' do
      sign_in(author)
      visit question_path(question)

      expect(page).to have_content(answer.body)

      click_on 'Delete Answer'

      expect(page).to have_content 'Your answer succesfully deleted.'
      expect(page).to_not have_content answer.body
    end

    scenario "deletes someone else's answer" do
      sign_in(create(:user))
      visit question_path(question)

      expect(page).to have_content(answer.body)
      expect(page).to_not have_content 'Delete Answer'
    end
  end

  scenario 'A non-authenticated user tries to delete the answer' do
    visit question_path(question)
    expect(page).to have_content(answer.body)
    expect(page).to_not have_content 'Delete Answer'
  end
end