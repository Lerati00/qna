FactoryBot.define do
  factory :subscription do
    user { create(:user) }

    trait :for_question do
      association(:subscribable, factory: :question)
    end
  end
end
