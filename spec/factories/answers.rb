FactoryBot.define do
  sequence :body do |n|
    "MyAnswerText#{n}"
  end

  factory :answer do
    body
    question { create(:question) }
    author { create(:user) }

    trait :with_link do
      links { create_list(:link, 1, :for_question)}
    end

    trait :with_file do
      files { fixture_file_upload(Rails.root.join('spec', 'rails_helper.rb'), 'rails_helper.rb') }
    end

    trait :with_comment do
      comments { create_list(:comment, 1, :for_question) }
    end

    trait :invalid do
      body { nil }
    end
  end
end
