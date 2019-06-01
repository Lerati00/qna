require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given(:simple_urls) { ['https://www.google.com/', 'https://opendedup.org/odd/'] }
  given(:gist_url) { 'https://github.com/thinknetica/qna/blob/8_nested_forms_and_polymoprphic/spec/features/question/add_links_spec.rb' }

  scenario 'User adds link when asks answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Your answer', with: 'text text text'

    click_on 'Add link'
    click_on 'Add link'

    nested_fields = all('div.nested-fields')

    nested_fields.each.with_index do |context, index|
      within context do
        fill_in 'Link name', with: 'My link'
        fill_in 'Url', with: simple_urls[index]
      end
    end

    click_on 'Create'

    within '.answers' do
      simple_urls.each { |url| expect(page).to have_link 'My link', href: url }
    end
  end

end
