require 'rails_helper'

feature 'Author of the Question can mark best Answer', "
  In order to mark Answer that can help in Question
  As an author of Question
  I'd like to be able to mark best Answer
" do

  scenario "Unauthenticated User can't choose best Answer"

  describe 'Authenticated user' do
    scenario 'can mark best Answer'
    scenario 'can mark only one best Answer'
    scenario "can't choose best Answer if not an author"
  end

end