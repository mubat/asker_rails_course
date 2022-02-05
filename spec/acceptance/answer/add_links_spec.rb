require 'rails_helper'

feature 'User can add links to Answer', "
  In order to provide additional info to my Answer
  As an Answer's author
  I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:testing_url) { 'https://www.youtube.com/watch?v=dQw4w9WgXcQ' }

  scenario 'User adds link when asks Answer', js: true do
    login(user)
    visit question_path(question)

    fill_in 'Answer', with: 'Test answer'

    fill_in 'Link name', with: 'Very important link'
    fill_in 'Url', with: testing_url

    click_on 'Answer it'
    within '.answers' do
      expect(page).to have_link 'Very important link', href: testing_url
    end
  end
end
