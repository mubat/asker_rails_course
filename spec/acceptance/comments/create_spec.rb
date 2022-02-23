require 'rails_helper'

feature 'Authorized users can add Comments to Questions and Answers', "
  In order to allows users put them notes to the Questions and Answers
  As an authenticated user
  I'd like to be able to add my Comment to the Question or Answers that I see
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authenticated user' do
    background do
      login(user)
      visit question_path(question)
    end

    describe 'for Question' do
      scenario 'can create new Comment'
    end

    describe 'for Answer' do
      scenario 'can create new Comment'
    end
  end

  describe 'Unauthenticated user' do
    background { visit question_path(question) }

    scenario 'can not add comment for Question'

    scenario 'can not add comment for Answer'
  end
end
