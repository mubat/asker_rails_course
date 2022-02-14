require 'rails_helper'

feature "User can set his vote on a Answer", "
  In order to increase rating of the Answer
  As an authenticated user
  I'd like to be able to set my like/dislike for each Answer
" do

  describe 'Authenticated user' do
    given(:user) { create(:user) }
    given(:question) { create(:question) }
    given!(:answer) { create(:answer, question: question) }

    background { login (user) }

    scenario "can set a vote" do
      visit question_path(question)

      within "#answer-#{answer.id}" do
        expect(page).to have_link 'Like'
        expect(page).to have_link 'Dislike'

        click_on 'Like'

        expect(page).to have_no_link 'Like'
        expect(page).to have_no_link 'Dislike'
      end
    end

    scenario "can't set same vote twice"
    scenario "can't set a vote to his Answer"
    scenario "can remote his previously set vote"
  end

  scenario "Unauthorized user can't set a vote"

  scenario 'User can view Answer rating'
end

