require 'rails_helper'

feature 'User can add links to question', "
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given(:testing_url) { 'https://www.youtube.com/watch?v=dQw4w9WgXcQ' }

  scenario 'User adds several links when asks question', js: true do
    login(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Test test test'

    click_on 'Add link'

    fill_in 'Link name', with: 'Very important link'
    fill_in 'Url', with: testing_url

    click_on 'Add link'

    within '.nested-fields:nth-of-type(2)' do
      fill_in 'Link name', with: 'Very important link2'
      fill_in 'Url', with: testing_url
    end
    click_on 'Ask'

    expect(page).to have_link 'Very important link', href: testing_url
    expect(page).to have_link 'Very important link2', href: testing_url
  end
end
