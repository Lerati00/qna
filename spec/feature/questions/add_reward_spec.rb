require 'rails_helper'

feature 'User can create reward for best answer', %q{
  In order to praise other users
  User can add reward to question
} do
  given(:user) { create(:user) }

  background do
    sign_in user
  end

  scenario 'Author can add reward while creating question' do
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text'

    fill_in 'Reward title', with: 'Reward test title'
    attach_file 'Image', "#{Rails.root}/tmp/images/images.jpeg"

    click_on 'Ask'

    expect(page).to have_content 'Your question successfully created'
  end
end