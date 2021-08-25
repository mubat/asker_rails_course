require 'rails_helper'

feature 'User can edit this answer', "
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
" do
  scenario "Unauthenticated user can't edit answer"

  describe 'Authenticated user' do
    scenario 'edits an answer'
    scenario 'edits an answer with errors'
    scenario "tries to edit other user's answer"
  end
end
