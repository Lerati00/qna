FactoryBot.define do
  factory :comment do
    body { 'My comment' }
    user { create(:user) }

    trait :invalid do
      body { nil }
    end

    trait :for_question do
      association(:commentable, factory: :question)
    end
  end
end
