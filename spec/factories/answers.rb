FactoryBot.define do
  factory :answer do
    body { "MyAnswer" }
    user
    question

    trait :invalid do
      body { nil }
    end

    trait :random do
      body { Faker::Lorem.sentence }
    end
  end
end
