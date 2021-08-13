require 'rails_helper'

feature "Authorized user can add answer on the question's view", "
  In order to give answers
  As an authenticated user
  I'd like to be able to add my answer to the question that I see
" do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authenticated user' do
    background do
      login(user)

      visit question_path(question)
    end

    scenario 'Can add a new answer' do
      fill_in 'Your Answer', with: 'Test answer'
      click_on 'Answer it'

      expect(current_path).to eq question_path(question)
      expect(page).to have_content 'Test answer' # TODO test in progress
    end

    scenario "Can't add an empty answer"
  end

  scenario "Can't add a new answer"
end