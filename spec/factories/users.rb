FactoryBot.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end

  factory :user do
    email
    password { '12345678' }
    password_confirmation { '12345678' }
    confirmed_at { Time.now.utc }
  
    trait :unconfirmed do
      confirmed_at { nil }
    end

    trait :confirmed do
      confirmed_at { Time.now.utc }
    end

    trait :with_auth do
      authorizations { create_list(:authorization, 1) }
    end
  end  
end
