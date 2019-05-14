require 'rails_helper'

feature 'User can view the question and the answers to this question' do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given(:answers) { create_list(:answer, 3, question: question) }

  scenario 'User can view the question and the answers to this question' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body

    question.answers.each { |answer| expect(page).to have_content answer.body }
  end
end