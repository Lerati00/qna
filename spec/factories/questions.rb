FactoryBot.define do
  sequence :title do |n|
    "MyQuestion#{n}"
  end

  factory :question do
    title
    body { "MyText" }
  end

  trait :with_file do
    files { fixture_file_upload(Rails.root.join('spec', 'rails_helper.rb'), 'rails_helper.rb') }
  end

  trait :invalid do
    title { nil }
  end
end
