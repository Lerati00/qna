require 'rails_helper'

feature 'User can see questions list' do

  given(:user) { create(:user) }
  given(:question) {create(:question, author: user) }
  given!(:rewards) { create_list(:reward, 3, question: question) }

  scenario 'User see rewads list' do
    sign_in(user)
    user.rewards << rewards
    visit rewards_path
    

    rewards.each do |reward|
      expect(page).to have_content reward.title
    end
  end
end


