FactoryBot.define do
  factory :question do
    title { "MyString" }
    body { "MyText" }

    trait :invalid do
      title { nil }
    end

    factory :question_with_answers do
      transient do
        answers_count { 3 }
      end

      after(:create) do |question, evaluator|
        create_list(:answer, evaluator.answers_count, :random, question: question)

        # You may need to reload the record here, depending on your application
        question.reload
      end
    end
  end
end
