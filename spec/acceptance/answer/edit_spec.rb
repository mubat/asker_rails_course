require 'rails_helper'

feature 'User can edit this answer', "
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
" do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) do
    create(:answer, question: question, user: user, files: [fixture_file_upload("#{Rails.root}/spec/rails_helper.rb")])
  end

  scenario "Unauthenticated user can't edit answer" do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    background do
      login(user)
      visit question_path(question)
    end

    scenario 'edits an answer', js: true do
      click_on 'Edit'
      within '.answers' do
        fill_in 'Your answer', with: 'some test answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'some test answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario "add files on answer's edit", js: true do
      within "#answer-#{answer.id}" do
        expect(page).to have_link 'rails_helper.rb'
        click_on 'Edit'

        expect(page).to have_field 'Your answer' # just to check that update form present

        attach_file 'Files', ["#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'

        expect(page).to_not have_selector 'form'
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'edits an answer with errors', js: true do
      within ".answers #answer-#{answer.id}" do
        click_on 'Edit'

        fill_in 'Your answer', with: ''
        click_on 'Save'

        expect(page).to have_content answer.body
        expect(page).to have_content "Answer can't be blank"
        expect(page).to have_selector 'textarea'
      end
    end

    scenario 'can remove files from answer', js: true do
      within "#answer-#{answer.id}" do
        expect(page).to have_link 'rails_helper.rb'

        click_on 'Delete file'

        expect(page).to_not have_link 'rails_helper.rb'
      end
    end

    scenario "tries to edit other user's answer" do
      other_user = create(:user)
      answer_other_user = create(:answer, question: question, user: other_user)

      visit question_path(question)
      within ".answers #answer-#{answer_other_user.id}" do
        expect(page).to_not have_link 'Edit'
        expect(page).to_not have_selector 'form'
      end
    end
  end
end
