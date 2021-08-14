require 'rails_helper'

feature 'User can signup', "
  In order to allow to ask questions
  As an unauthenticated user
  I'd like to be able signup
" do

  given(:user) { create :user }
  background { visit new_user_registration_path }

  describe 'Unregistered user' do

    scenario 'can signup'

    scenario 'can not signup without password'

    scenario 'can not signup without login'

  end

  scenario 'Registered user can not signup'

  scenario 'Authenticated user can not signup again' do
    login(user)
    visit new_user_registration_path

    expect(current_path).to eq root_path
    expect(page).to have_content 'You are already signed in.'
  end

end
