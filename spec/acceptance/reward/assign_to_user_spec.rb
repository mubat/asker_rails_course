require 'rails_helper'

feature "User takes Reward when Question's author choose best Answer", "
  In order to reward User with best Answer
  As and Question's author
  I'd like to be able to give Reward to Answer's author when mark best answer
" do

  given(:question_author) { create(:user) }
  given(:question) { create(:question, user: question_author) }
  given(:answer_author) { create(:user) }
  given(:answer) { create(:answer, user: answer_author) }

  scenario 'User takes Reward when his Answer marked as best' do

  end

  scenario "Question's author doesn't take a reward when mark his answer as best"
end