require 'rails_helper'

feature "User can see answers on the question's view", "
  In order to find answer that need for me
  As an user
  I'd like to be able to see all answers of the question
" do

  given!(:question) { create(:question) }
  given!(:question_with_answers) { create(:question_with_answers, answers_count: 4) }

  scenario "Can see answers on the question's view" do
    visit question_path(question_with_answers)

    expect(question_with_answers.answers.length).to eq(4)
    question_with_answers.answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end

  scenario "Can see label that question doesn't has answers" do
    visit question_path(question)

    expect(question.answers).to be_empty
    expect(page).to have_content 'Still no answer here'
  end
end

