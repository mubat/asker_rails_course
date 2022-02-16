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

    scenario "can set a vote", js: true do
      visit question_path(question)

      within "#answer-#{answer.id}" do
        expect(page).to have_link 'Like'
        expect(page).to have_link 'Dislike'

        click_on 'Like'

        # check links on voted Answers without reload page
        expect(page).to have_no_link 'Like'
        expect(page).to have_no_link 'Dislike'

        visit current_path

        # check links on voted Answers after loading page
        expect(page).to have_no_link 'Like'
        expect(page).to have_no_link 'Dislike'
      end
    end

    scenario "can't set a vote to his Answer" do
      user_answer = create(:answer, question: question, user: user)
      visit question_path(question)

      within "#answer-#{user_answer.id}" do
        expect(page).to have_no_link 'Like'
        expect(page).to have_no_link 'Dislike'
      end
    end
    scenario "can remove his previously set vote", js: true do
      create(:vote, votable: answer, user: user)
      visit question_path(question)

      within "#answer-#{answer.id}" do
        expect(page).to have_no_link 'Like'
        expect(page).to have_no_link 'Dislike'

        click_on 'Reset vote'

        expect(page).to have_link 'Like'
        expect(page).to have_link 'Dislike'
        expect(page).to have_no_link 'Reset vote'
      end
    end
  end

  scenario "Unauthorized user can't set a vote"

  scenario 'User can view Answer rating'
end

