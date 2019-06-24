require 'rails_helper'

feature 'User can sign up', %q{
  In order to ask questions
  As an unauthenticated user
  I'd like to be able to sign in
} do

  given(:user) { create(:user) }

  background { visit new_user_registration_path }

  scenario 'Unregistered user tries to sign up' do 
    fill_in 'Email', with: 'new_user@mail'
    fill_in 'Password', with: '111111'
    fill_in 'Password confirmation', with: '111111'
    click_on 'Sign up'

    expect(page).to have_content 'A message with a confirmation link has been sent to your email address. Please follow the link to activate your account.'
  end

  scenario 'Unregistered user tries to sign up with errors' do
    click_on 'Sign up'

    expect(page).to have_content "Email can't be blank"
  end

  scenario 'Registered user try to sign up' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password_confirmation
    click_on 'Sign up'

    expect(page).to have_content "Email has already been taken"
  end
end