require 'rails_helper'

feature 'User can add links to question', "
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given(:testing_url) { 'https://www.youtube.com/watch?v=dQw4w9WgXcQ' }

  scenario 'User adds link when asks question' do
    login(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Test test test'

    fill_in 'Link name', with: 'Very important link'
    fill_in 'Url', with: testing_url

    click_on 'Ask'

    expect(page).to have_link 'Very important link', href: testing_url
  end
end
