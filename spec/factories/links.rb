FactoryBot.define do
  factory :link do
    name { "MyString" }
    url { "https://github.com" }
    linkable { create(:question, author: create(:user)) }

    trait :with_invalid_url do 
      url { 'http:/myinvalidurl' }
    end
  end
end
