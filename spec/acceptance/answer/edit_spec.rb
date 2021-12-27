require 'rails_helper'

feature 'User can edit this answer', "
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
" do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario "Unauthenticated user can't edit answer" do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do

    scenario 'edits an answer', js: true do
      login(user)
      visit question_path(question)

      click_on 'Edit'
      within '.answers' do
        fill_in 'Your answer', with: 'some test answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'some test answer'
        expect(page).to_not have_selector 'textarea'
      end
    end
    
    scenario 'edits an answer with errors', js: true do
      login(user)
      visit question_path(question)


      within ".answers #answer-#{answer.id}" do
        click_on 'Edit'
        
        fill_in 'Your answer', with: ''
        click_on 'Save'

        expect(page).to have_content answer.body
        expect(page).to have_content "Answer can't be blank"
        expect(page).to have_selector 'textarea'
      end
    end

    scenario "tries to edit other user's answer" do
      other_user = create(:user)
      answer_other_user = create(:answer, question: question, user: other_user)
      login(user)
      visit question_path(question)

      within ".answers #answer-#{answer_other_user.id}" do
        expect(page).to_not have_link 'Edit'
        expect(page).to_not have_selector 'form'
      end
    end
  end
end
