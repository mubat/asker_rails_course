require 'rails_helper'

feature "User can set his vote on a Answer", "
  In order to increase rating of the Answer
  As an authenticated user
  I'd like to be able to set my like/dislike for each Answer
" do

  describe 'Authenticated user' do
    scenario "can set a vote"
    scenario "can't set same vote twice"
    scenario "can't set a vote to his Answer"
    scenario "can remote his previously set vote"
  end

  scenario "Unauthorized user can't set a vote"

  scenario 'User can view Answer rating'
end

