FactoryBot.define do
  factory :comment do
    body { 'My comment' }

    trait :invalid do
      body { nil }
    end
  end
end
