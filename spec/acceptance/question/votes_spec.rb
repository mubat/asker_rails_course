require 'rails_helper'

feature 'User can set his vote on a Question', "
  In order to increase rating of the Question
  As an authenticated user
  I'd like to be able to set my like/dislike for each Question
" do
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    given(:user) { create(:user) }

    background { login (user) }

    scenario 'can set a vote'

    scenario "can't set a vote to his Question"

    scenario 'can remove his previously set vote'

    describe 'changes a rating' do
      scenario 'after set a vote'

      scenario 'after remove his vote'
    end
  end

  scenario "Unauthorized user can't set a vote" do
    visit question_path(question)

    within '.question-data' do
      expect(page).to have_no_link 'Like'
      expect(page).to have_no_link 'Dislike'
      expect(page).to have_no_link 'Reset vote'
    end
  end

  describe 'User can view Question rating' do
    scenario 'when several votes presents'

    scenario 'when no one votes presents'
  end
end

