require 'rails_helper'

feature 'User can edit his own question', "
  In order to get allow correct user's question
  As an authenticated user - owner of the question
  I'd like to be able to update question text
" do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user, files: [fixture_file_upload("#{Rails.root}/spec/rails_helper.rb")]) }

  describe 'Question creator' do
    background do
      login(user)
      visit question_path(question)
    end

    scenario "Can edit his question", js: true do
      within '.question-data' do
        expect(page).to_not have_selector 'form'

        click_on 'Edit'

        expect(page).to_not have_link 'Edit'

        fill_in 'Title', with: 'new title'
        fill_in 'Body', with: 'new body'
        click_on 'Save'

        expect(page).to_not have_selector 'form'
        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to have_content 'new title'
        expect(page).to have_content 'new body'
        expect(page).to have_link 'Edit'
      end

    end

    scenario 'can add files while editing a question', js: true do
      within '.question-data' do
        expect(page).to have_link 'rails_helper.rb'

        click_on 'Edit'

        expect(page).to have_field 'Title' # just to check that update form present

        attach_file 'File', ["#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'

        expect(page).to have_link 'spec_helper.rb'
        expect(page).to have_link 'rails_helper.rb'
      end
    end

    scenario 'can remove files from question', js: true do
      within '.question-data' do
        expect(page).to have_link 'rails_helper.rb'

        click_on 'Delete file'

        expect(page).to_not have_link 'rails_helper.rb'
      end

    end
  end

  describe 'Other user' do
    given(:other_user) { create(:user) }

    scenario "Can't edit question" do
      login(other_user)
      visit question_path(question)

      within '.question-data' do
        expect(page).to_not have_link 'Edit'
        expect(page).to_not have_selector 'form'
      end

    end

    scenario "Can't delete files" do
      login(other_user)
      visit question_path(question)

      within "#attachment-#{question.files.first.id}" do
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to_not have_link 'Delete file'
      end

    end
  end
end
