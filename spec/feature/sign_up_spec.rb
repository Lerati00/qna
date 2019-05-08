require 'rails_helper'

feature 'User can sign up', %q{
  In order to ask questions
  As an unauthenticated user
  I'd like to be able to sign in
} do

  scenario 'Unregistered user tries to sign up'
  scenario 'Unregistered user tries to sign up with errors'
  scenario 'Registered user try to sign up'
end