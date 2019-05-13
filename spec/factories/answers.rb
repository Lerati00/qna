FactoryBot.define do
  sequence :body do |n|
    "MyTextAnswer#{n}"
  end

  factory :answer do
    body
    question { nil }

    trait :invalid do
      body { nil }
    end
  end
end
