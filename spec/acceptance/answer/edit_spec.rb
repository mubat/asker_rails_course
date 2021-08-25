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
    scenario 'edits an answer'
    scenario 'edits an answer with errors'
    scenario "tries to edit other user's answer"
  end
end
