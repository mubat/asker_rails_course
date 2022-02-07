require 'rails_helper'

feature 'User can add reward to question', "
  In order to reward user who gave a correct answer
  As an question's author
  I'd like to be able to add reward
" do

  describe 'Authenticated User' do
    scenario "can populate reward on Question's creation"

    scenario "can't create Question with invalid image"

    scenario "can't create Question with empty award image"

    scenario "can't create Question with empty award name"
  end
end
