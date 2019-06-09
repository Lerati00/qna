FactoryBot.define do
  sequence :title do |n|
    "MyQuestion#{n}"
  end

  factory :question do
    title
    body { "MyText" }
    author { create(:user) }

    trait :with_link do
      links { create_list(:link, 1, :for_question)}
    end

    trait :with_file do
      files { fixture_file_upload(Rails.root.join('spec', 'rails_helper.rb'), 'rails_helper.rb') }
    end

    trait :with_reward do
      reward { create(:reward, :for_question) }
    end

    trait :invalid do
      title { nil }
    end
  end
  
end
