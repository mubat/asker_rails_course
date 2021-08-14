require 'rails_helper'

feature 'User can logout', "
  In order to allow to end user session
  As an unauthenticated user
  I'd like to be able to logout
" do

  given(:user) { create :user }

  scenario 'Authenticated user can logout' do
    login(user)
    click_on 'Log out'
    expect(page).to have_content 'Signed out successfully.'
  end

  scenario 'Unauthenticated user can not logout' do
  end

end

