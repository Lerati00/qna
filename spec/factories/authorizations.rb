FactoryBot.define do
  sequence :uid do |n|
    "#{n}#{n+1}#{+2}"
  end

  factory :authorization do
    user { create(:user) }
    provider { "MyString" }
    uid 
  end
end