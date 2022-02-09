require 'rails_helper'

feature "User can view his Rewards", "
  In order to indulge your ego :)
  As an Reward's receiver
  I'd like to see all my Rewards with Questions
" do
  describe 'Authenticated user' do
    describe 'see his Rewards'

    describe "see 'No rewards' message when has no one Reward"
  end

  scenario 'Unauthenticated User doesnt view My rewards link'
end