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

    scenario 'can not login with invalid password' do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: Faker::Internet.password(min_length: 8)
      click_on 'Log in'

      expect(page).to have_content "Invalid Email or password."
      expect(current_path).to eq new_user_session_path
    end

  end

  scenario 'Unregistered user can not login' do
    fill_in 'Email', with: Faker::Internet.email
    fill_in 'Password', with: Faker::Internet.password(min_length: 8)
    click_on 'Log in'

    expect(page).to have_content "Invalid Email or password."
    expect(current_path).to eq new_user_session_path
  end

end
