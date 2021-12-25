require 'rails_helper'

feature 'User can edit his own question', "
  In order to get allow correct user's question
  As an authenticated user - owner of the question
  I'd like to be able to update question text
" do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Question creator' do
    scenario "Can edit his question", js:true do 
      login(user)
      visit question_path(question)

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
  end

  describe 'Other user' do
    scenario "Can't edit question"
  end
end
