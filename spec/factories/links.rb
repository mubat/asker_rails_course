FactoryBot.define do
  factory :link do
    name { Faker::Internet.domain_word }
    url { Faker::Internet.url }
  end
end
