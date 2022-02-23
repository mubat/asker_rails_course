FactoryBot.define do
  factory :comment do
    body { "Comment #{Faker::Game.title}" }
    user
    association(:commentable, factory: :question)

    trait :empty_body do
      body { nil }
    end
  end
end
