require 'rails_helper'

feature 'User can edit this answer', "
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
" do

  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  scenario "Unauthenticated user can't edit answer" do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    given!(:user) { create(:user) }

    scenario 'edits an answer' do
      login(user)
      visit question_path(question)

      click_on 'Edit'
      within '.answers' do
        fill_in 'Your answer', with: 'some test answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'some test answer'
        expect(page).to_not have_selector 'textarea'
      end
    end
    scenario 'edits an answer with errors'
    scenario "tries to edit other user's answer"
  end
end
