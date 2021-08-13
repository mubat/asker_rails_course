require 'rails_helper'

feature "Authorized user can add answer on the question's view", "
  In order to give answers
  As an authenticated user
  I'd like to be able to add my answer to the question that I see
" do

  given!(:question) { create(:question) }

  describe 'Authenticated user' do
    scenario 'Can add a new answer'
    scenario "Can't add an empty answer"
  end

  scenario "Can't add a new answer"
end
