require 'rails_helper'

feature "Authenticated user can destroy his own answers on the question's view", "
  In order to remove not actual answer
  As an authenticated user
  I'd like to be able to my answers of the question
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:other_question) { create(:question_with_answers) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe "Authenticated user" do
    background do
      login(user)
    end

    scenario "Can destroy answers" do
      visit question_path(question)
      click_on 'Delete answer'

      expect(current_path).to eq question_path(question)
      expect(page).not_to have_content answer.body
    end

    scenario "Can't destroy not his own answer" do
      visit question_path(other_question)

      expect(page).not_to have_link 'Delete answer'
    end
  end

  scenario "Unauthenticated user can't destroy answers" do
    visit question_path(other_question)

    expect(page).not_to have_link 'Delete answer'
  end
end

