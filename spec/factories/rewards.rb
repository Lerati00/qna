FactoryBot.define do
  factory :reward do
    sequence :title do |n|
      "MyTextReward#{n}"
    end
    
    image { fixture_file_upload(Rails.root.join('tmp/images', 'images.jpeg'), 'images.jpeg') }
    
    trait :for_question do
      question { create(:question, author: create(:user)) }
    end
  end
end
