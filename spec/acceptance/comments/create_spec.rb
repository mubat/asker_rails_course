require 'rails_helper'

feature 'Authorized users can add Comments to Questions and Answers', "
  In order to allows users put them notes to the Questions and Answers
  As an authenticated user
  I'd like to be able to add my Comment to the Question or Answers that I see
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    background { login(user) }

    describe 'for Question' do
      scenario 'can create new Comment' do
        visit question_path(question)

        within '.question-data .comments-container' do
          expect(page).not_to have_content "Question's comment"
          fill_in 'Comment', with: "Question's comment"

          click_on 'Add comment'

          expect(page).to have_content "Question's comment"
          expect(page).to_not have_field(:comment, with: "Question's comment")
        end
      end

      scenario 'can create new Comment for his own Question' do
        users_question = create(:question, user: user)
        visit question_path(users_question)

        within '.question-data .comments-container' do
          expect(page).not_to have_content "Question's comment"
          fill_in 'Comment', with: "Question's comment"

          click_on 'Add comment'

          expect(page).to have_content "Question's comment"
          expect(page).to_not have_field(:comment, with: "Question's comment")
        end
      end
    end

    describe 'for Answer' do
      scenario 'can create new Comment' do
        answer = create(:answer, question: question)
        visit question_path(question)

        within "#answer-#{answer.id} .comments-container" do
          expect(page).not_to have_content "Answer's comment"
          fill_in 'Comment', with: "Answer's comment"

          click_on 'Add comment'

          expect(page).to have_content "Answer's comment"
          expect(page).to_not have_field(:comment, with: "Answer's comment")
        end
      end

      scenario 'can create new Comment for his own Answer' do
        user_answer = create(:answer, question: question, user: user)
        visit question_path(question)

        within "#answer-#{user_answer.id} .comments-container" do
          expect(page).not_to have_content "Answer's comment"
          fill_in 'Comment', with: "Answer's comment"

          click_on 'Add comment'

          expect(page).to have_content "Answer's comment"
          expect(page).to_not have_field(:comment, with: "Answer's comment")
        end
      end
    end
  end

  describe 'Unauthenticated user' do
    background { visit question_path(question) }

    scenario 'can not add comment for Question and Answer' do
      expect(page).not_to have_link 'Add comment'
      expect(page).not_to have_content 'Comment'
    end
  end
end
