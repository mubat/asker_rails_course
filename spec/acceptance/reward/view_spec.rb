require 'rails_helper'

feature "User can view his Rewards", "
  In order to indulge your ego :)
  As an Reward's receiver
  I'd like to see all my Rewards with Questions
" do
  describe 'Authenticated user' do
    given(:user) { create :user }
    given(:question) { create :question, user: create(:user) }
    given!(:rewards) { create_list :reward, 2, user: user }

    background do
    end

    scenario 'see his Rewards' do
      login(user)
      visit questions_path
      click_on 'My rewards'

      rewards.each do |reward|
        expect(page).to have_link reward.question.title, href: question_path(reward.question)
        expect(page).to have_content reward.name
        expect(page).to have_css("img[src*='#{reward.image.filename}']")
      end
    end

    scenario "see 'No rewards' message when has no one Reward" do
      login(create(:user))
      visit rewards_path

      expect(page).to have_content 'You have no rewards for now'
    end
  end

  scenario 'Unauthenticated User doesnt view My rewards link'
end