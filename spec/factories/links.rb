FactoryBot.define do
  factory :link do
    name { "MyString" }
    url { Faker::Internet.url }
  end
end
