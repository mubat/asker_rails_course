require 'rails_helper'

feature 'User can add reward to question', "
  In order to reward user who gave a correct answer
  As an question's author
  I'd like to be able to add reward
" do

  describe 'Authenticated User' do
    given(:user) { create :user }

    background do
      login(user)
    end

    scenario "can populate reward on Question's creation" do
      visit questions_path
      click_on 'Ask question'
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      within '.award' do
        fill_in 'Name', with: 'Award name'
        attach_file 'Image', Rails.root.join('spec/fixtures/test_img.jpg')
      end

      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content 'For the best answer you will receive'
      expect(page).to have_content 'Award name'
      expect(page).to have_css("img[src*='test_img.jpg']")
    end

    scenario "can't create Question with invalid image"

    scenario "can't create Question with empty award image"

    scenario "can't create Question with empty award name"
  end
end