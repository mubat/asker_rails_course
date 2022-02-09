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
      visit new_question_path

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

    end

    scenario "can populate reward on Question's creation" do
      within '.reward' do
        fill_in 'Name', with: 'Award name'
        attach_file 'Image', Rails.root.join('spec/fixtures/test_img.jpg')
      end

      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content 'For the best answer author will receive'
      expect(page).to have_content 'Award name'
      expect(page).to have_css("img[src*='test_img.jpg']")
    end

    scenario "can't create Question with invalid image" do
      within '.reward' do
        fill_in 'Name', with: 'Award name'
        attach_file 'Image', Rails.root.join('spec/spec_helper.rb')
      end

      click_on 'Ask'

      expect(page).to_not have_content 'Your question successfully created.'
      expect(page).to_not have_content 'Test question'
      expect(page).to_not have_content 'Award name'
      expect(page).to have_content "Reward image has an invalid content type"
    end

    scenario "can't create Question with empty award image" do
      within '.reward' do
        fill_in 'Name', with: 'Award name'
      end

      click_on 'Ask'

      expect(page).to_not have_content 'Your question successfully created.'
      expect(page).to_not have_content 'Test question'
      expect(page).to_not have_content 'Award name'
      expect(page).to have_content "Reward image can't be blank"
    end

    scenario "can't create Question with empty award name" do
      within '.reward' do
        attach_file 'Image', Rails.root.join('spec/spec_helper.rb')
      end

      click_on 'Ask'

      expect(page).to_not have_content 'Your question successfully created.'
      expect(page).to_not have_content 'Test question'
      expect(page).to_not have_content 'Award name'
      expect(page).to have_content "Reward name can't be blank"
    end
  end
end
