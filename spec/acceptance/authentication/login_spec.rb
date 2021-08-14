require 'rails_helper'

feature 'User can login', "
  In order to allow to ask questions
  As an unauthenticated user
  I'd like to be able to login
" do
  given(:user) { create :user }
  background { visit new_user_session_path }

  describe 'Registered user' do
    scenario 'can login' do
      login(user)

      expect(page).to have_content 'Signed in successfully.'
    end

    scenario 'can not login with invalid password'

  end

  scenario 'Unregistered user can not login'

end
