require 'rails_helper'

feature 'User can delete links from Question', "
  In order to allow to remove links my Question
  As an Question's author
  I'd like to be able to delete links
" do

  describe 'Authenticated user' do
    given(:user) { create :user }
    given(:question) { create :question, user: user }
    given!(:links) { create_list :link, 2, linkable: question }

    scenario 'can remove links from question', js: true do
      login(user)
      visit question_path(question)

      within '.question-data' do
        expect(page).to have_link links.first.name
        expect(page).to have_link links.second.name

        within "#link-#{links.second.id}" do
          click_on 'Delete link'
        end

        expect(page).to have_link links.first.name
        expect(page).to_not have_link links.second.name
      end
    end

    scenario "can't remove links of another author's answer" do
      other_user = create(:user)
      login(other_user)
      visit question_path(question)

      within ".question-data" do
        expect(page).to have_link links.first.name
        expect(page).to_not have_link 'Delete link'
      end
    end
  end

  describe "Unauthorized User can't delete links from Question"
end
