require 'rails_helper'

feature 'User can destroy his own question', "
  In order to remove unnecessary question
  As a authenticated user
  I'd like to be able to destroy question created by me
" do

  given(:user) { create :user }
  given(:question) { create :question, user: user }
  given(:another_question) { create :question }

  describe 'Authenticated user' do
    background { login(user) }

    scenario 'destroys his question' do
      visit question_path(question)
      expect(page).to have_content(question.title)

      click_on 'Delete question'

      expect(page).to have_content('Your question successfully destroyed.')
      expect(page).not_to have_content(question.title)
      expect(current_path).to eq questions_path
    end

    scenario 'can not destroy not his question' do
      visit question_path(another_question)

      expect(page).to have_no_link('Delete question')
    end
  end

  scenario 'Unauthenticated user tries to destroy question' do
    visit question_path(question)

    expect(page).to have_no_link('Delete question')
  end
end
