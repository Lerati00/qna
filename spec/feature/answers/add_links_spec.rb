require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given(:simple_urls) { ['https://www.google.com/', 'https://opendedup.org/odd/'] }
  given(:gist_url) { 'https://gist.github.com/Lerati00/46f87d2c01b664f6c33955469894b40c' }


  scenario 'User adds link when write answer', js: true do
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

  scenario 'User adds gist link when write answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Your answer', with: 'text text text'

    click_on 'Add link'
    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Create'
  
    within '.links-list' do
      expect(page).to have_link 'My gist', href: gist_url
      expect(page).to have_content 'My gists content'
    end
  end

end
