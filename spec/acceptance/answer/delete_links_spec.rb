require 'rails_helper'

feature 'User can delete links from Answer', "
  In order to allow to remove links my Answer
  As an Answer's author
  I'd like to be able to delete links
" do

  given(:user) { create :user }
  given(:answer) { create :answer, question: create(:question), user: user }
  given!(:links) { create_list :link, 2, linkable: answer }

  describe 'Authenticated user' do

    scenario 'can remove links from answer', js: true do
      login(user)
      visit question_path(answer.question)

      within "#answer-#{answer.id}" do
        expect(page).to have_link links.first.name
        expect(page).to have_link links.second.name
      end

      within "#link-#{links.second.id}" do
        click_on 'Delete link'
      end

      within "#answer-#{answer.id}" do
        expect(page).to have_link links.first.name
        expect(page).to_not have_link links.second.name
      end
    end

    scenario "can't remove links of another author's answer" do
      other_user = create(:user)
      login(other_user)
      visit question_path(answer.question)

      within "#answer-#{answer.id}" do
        expect(page).to have_link links.first.name
        expect(page).to_not have_link 'Delete link'
      end
    end
  end

  scenario "Unauthorized User can't delete links from Answer" do
      visit question_path(answer.question)
      
      within "#answer-#{answer.id}" do
        expect(page).to have_link links.first.name
        expect(page).to_not have_link 'Delete link'
      end
  end
end
