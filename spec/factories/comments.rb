FactoryBot.define do
  factory :comment do
    sequence :body do |n|
      "MyCommentText#{n}"
    end 

    user { create(:user) }

    trait :invalid do
      body { nil }
    end

    trait :for_question do
      association(:commentable, factory: :question)
    end
  end
end
