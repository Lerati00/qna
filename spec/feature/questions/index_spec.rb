require 'rails_helper'

feature 'User can see questions list' do

  given!(:questions) { create_list(:question, 3) }

  scenario 'User see questions list' do
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end
  end
end


