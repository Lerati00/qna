FactoryBot.define do
  factory :vote do
    user { create(:user) }
    score { 1 }

    trait :for_question do
      association(:votable, factory: :question)
    end
  end
end
