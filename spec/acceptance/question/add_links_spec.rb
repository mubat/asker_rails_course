require 'rails_helper'

feature 'User can add links to question', "
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given(:testing_url_name) { 'Very important link' }
  given(:testing_url) { 'https://www.youtube.com/watch?v=dQw4w9WgXcQ' }
  given(:wrong_url) { 'http:/wrongUrl' }

  describe 'Authenticated user' do
    background do
      login(user)
      visit new_question_path

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'Test test test'
    end

    scenario 'User adds several links when asks question', js: true do
      click_on 'Add link'

      fill_in 'Link name', with: testing_url_name
      fill_in 'Url', with: testing_url

      click_on 'Add link'

      other_name = 'other link name'

      within '.nested-fields:nth-of-type(2)' do
        fill_in 'Link name', with: other_name
        fill_in 'Url', with: testing_url
      end
      click_on 'Ask'

      expect(page).to have_link testing_url_name, href: testing_url
      expect(page).to have_link other_name, href: testing_url
    end

    scenario "User can't adds link with invalid URL when asks question", js: true do
      click_on 'Add link'

      fill_in 'Link name', with: testing_url_name
      fill_in 'Url', with: wrong_url

      click_on 'Ask'

      expect(page).to_not have_link testing_url_name
      expect(page).to have_content 'url is not a valid URL'
    end

    scenario 'can add link on Question update', js: true do
      question = create(:question, user: user)
      link = create(:link, linkable: question)

      visit question_path(question)

      within '.question-data' do
        click_on 'Edit'

        click_on 'Add link'

        fill_in 'Link name', with: 'Very important link'
        fill_in 'Url', with: testing_url

        click_on 'Save'

        expect(page).to have_link 'Very important link', href: testing_url
        expect(page).to have_link link.name, href: link.url
      end
    end
  end
end
