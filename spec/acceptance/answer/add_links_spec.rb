require 'rails_helper'

feature 'User can add links to Answer', "
  In order to provide additional info to my Answer
  As an Answer's author
  I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:testing_url_name) { "Answer's link" }
  given(:testing_url) { 'https://www.youtube.com/watch?v=dQw4w9WgXcQ' }
  given(:gist_url) { 'https://gist.github.com/edelpero/9257311' }
  given(:wrong_url) { 'http:/wrongUrl' }

  describe 'Authenticated user' do
    background do
      login(user)
      visit question_path(question)
      fill_in 'Answer', with: 'Test answer'
    end

    scenario 'adds link when asks Answer', js: true do
      click_on 'Add link'

      fill_in 'Link name', with: 'Very important link'
      fill_in 'Url', with: testing_url

      click_on 'Add link'

      within '.nested-fields:nth-of-type(2)' do
        fill_in 'Link name', with: 'Very important link2'
        fill_in 'Url', with: testing_url
      end

      click_on 'Answer it'
      within '.answers' do
        expect(page).to have_link 'Very important link', href: testing_url
      end
    end

    scenario "can't adds link with invalid URL when asks question", js: true do
      click_on 'Add link'

      fill_in 'Link name', with: 'Very important link'
      fill_in 'Url', with: 'http:/wrongUrl'

      click_on 'Answer it'

      expect(page).to_not have_link 'Very important link'
      expect(page).to have_content 'url is not a valid URL'
    end

    scenario "can adds link to Gist.Github.com and see it data", js: true do
      click_on 'Add link'

      fill_in 'Link name', with: 'Gist link'
      fill_in 'Url', with: gist_url

      click_on 'Answer it'

      expect(page).to_not have_link 'Very important link'
      expect(page).to have_content 'Heroku, Ruby on Rails and PhantomJS'
    end

    scenario 'can add link on Answer update', js: true do
      answer = create(:answer, question: question, user: user)
      link = create(:link, linkable: answer)

      visit current_path

      within "#answer-#{answer.id}" do
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
