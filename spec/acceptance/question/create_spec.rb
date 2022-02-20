require 'rails_helper'

feature 'User can create question', '
  In order to get answer from community
  As an authenticated user
  I\'d like to be able to ask question
' do

  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      login(user)

      visit questions_path
      click_on 'Ask question'
    end

    scenario 'asks a question' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'Test test test'
      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'Test test test'
    end

    scenario 'asks a question with errors' do
      click_on 'Ask'
      expect(page).to have_content "Title can't be blank"
    end

    scenario 'asks a question with attached file' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'Test test test'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Ask'
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  context 'multiple sessions', js: true do
    scenario "Question appears on another user's page" do
      Capybara.using_session('creator') do
        login(user)
        visit new_question_path
      end

      Capybara.using_session('watcher') do
        visit questions_path
      end

      Capybara.using_session('creator') do
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'Test test test'
        click_on 'Ask'

        expect(page).to have_content 'Your question successfully created.'
        expect(page).to have_content 'Test question'
        expect(page).to have_content 'Test test test'
      end

      Capybara.using_session('watcher') do
        expect(page).to have_content 'Test question'
      end
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need t1o sign in or sign up before continuing.'
  end
end
