require 'rails_helper'

feature "User takes Reward when Question's author choose best Answer", "
  In order to reward User with best Answer
  As a Question's author
  I'd like to be able to give Reward to Answer's author when mark best answer
" do

  given(:question_author) { create(:user) }
  given!(:question) { create(:question, user: question_author) }
  given!(:reward) { create(:reward, question: question) }
  given(:answer_author) { create(:user) }
  given!(:answer) { create(:answer, user: answer_author, question: question) }

  scenario 'User takes Reward when his Answer marked as best', js: true do
    login(question_author)
    visit question_path(question)

    within "#answer-#{answer.id}" do
      click_on 'Make answer best'
    end

    expect(page).to have_content "User #{answer_author.email} received a #{reward.name} reward"
    expect(answer_author.rewards).to eq [reward]
  end

  scenario "Question's author doesn't take a reward when mark his answer as best"
end