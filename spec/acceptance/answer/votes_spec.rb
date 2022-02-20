require 'rails_helper'

feature 'User can set his vote on a Answer', "
  In order to increase rating of the Answer
  As an authenticated user
  I'd like to be able to set my like/dislike for each Answer
" do

  given!(:answer) { create(:answer, question: question) }
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    given(:user) { create(:user) }

    background { login (user) }

    scenario 'can set a vote', js: true do
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
    scenario 'can remove his previously set vote', js: true do
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

    describe 'changes a rating' do
      scenario 'after set a vote', js: true do
        visit question_path(question)

        within "#answer-#{answer.id}" do
          expect(page).to have_content 'Rating: 0'
          click_on 'Dislike'
          expect(page).to have_content 'Rating: -1'
        end
      end

      scenario 'after remove his vote', js: true do
        create(:vote, votable: answer, user: user, degree: :like)
        visit question_path(question)

        within "#answer-#{answer.id}" do
          expect(page).to have_content 'Rating: 1'
          click_on 'Reset vote'
          expect(page).to have_content 'Rating: 0'
        end
      end
    end
  end

  scenario "Unauthorized user can't set a vote" do
    visit question_path(question)

    expect(page).to have_no_link 'Like'
    expect(page).to have_no_link 'Dislike'
    expect(page).to have_no_link 'Reset vote'
  end

  describe 'User can view Answer rating' do
    scenario 'when several votes presents' do
      create_list(:vote, 8, votable: answer, degree: :like)
      create_list(:vote, 5, votable: answer, degree: :dislike)
      visit question_path(question)

      within "#answer-#{answer.id}" do
        expect(page).to have_content 'Rating: 3' # 8 likes - 5 dislikes
      end
    end

    scenario 'when no one votes presents' do
      visit question_path(question)

      within "#answer-#{answer.id}" do
        expect(page).to have_content 'Rating: 0'
      end
    end
  end
end

