require 'rails_helper'

feature 'User sign in', '
  In order to be able to ask question
  As an user
  I want to be able to sign in
' do

  scenario 'Registered user try to sign in' do
    User.create!(email: 'user@test.com', password: '123123123')

    visit new_user_session_path
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '123123123'
    click_on 'Sign in'

    expect(page).to have_content 'Signed in successfully'
    expect(current_path).to eq root_path
  end

  scenario 'Non-registered user try to sign in' do
    visit new_user_session_path
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '123123123'
    click_on 'Sign in'

    expect(page).to have_content 'Invalid email or password.'
    expect(current).to eq new_user_session_path
  end

end
