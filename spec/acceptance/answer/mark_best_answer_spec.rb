require 'rails_helper'

feature 'Author of the Question can mark best Answer', "
  In order to mark Answer that can help in Question
  As an author of Question
  I'd like to be able to mark best Answer
" do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user, is_best: nil) }

  scenario "Unauthenticated User can't choose best Answer"

  describe 'Authenticated user' do
    background { login(user) }

    scenario 'can mark best Answer', js: true do
      visit question_path(question)

      within "#answer-#{answer.id}" do
        expect(page).to_not have_content 'Best answer'

        click_on 'Make answer best'

        expect(page).to have_text 'Best answer'
        expect(page).to_not have_text 'Make answer best'
        
        answer.reload
        expect(answer.is_best).to be_truthy
      end
    end
    scenario 'can mark only one best Answer'
    scenario "can't choose best Answer if not an author" do
      other_user = create(:user)
      other_question = create(:question, user: other_user)
      other_answer = create(:answer, question: other_question, user: user, is_best: nil)

      visit question_path(other_question)

      within "#answer-#{other_answer.id}" do
        expect(page).to_not have_text 'Make answer best'
      end
    end
  end

end