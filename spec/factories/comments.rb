FactoryBot.define do
  factory :comment do
    body { "Comment #{Faker::Game.title}" }
    user
    association(:commentable, factory: :question)
  end
end
