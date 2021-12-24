require 'rails_helper'

feature 'User can edit his own question', "
  In order to get allow correct user's question
  As an authenticated user - owner of the question
  I'd like to be able to update question text
" do

  given(:user) { create(:user) }

  describe 'Question creator' do
    scenario "Can edit his question"
  end

  describe 'Other user' do
    scenario "Can't edit question"
  end
end
