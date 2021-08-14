require 'rails_helper'

feature 'User can signup', "
  In order to allow to ask questions
  As an unauthenticated user
  I'd like to be able signup
" do

  given(:user) { create :user }
  background { visit new_user_registration_path }

  describe 'Unregistered user' do

    scenario 'can signup' do
      password = Faker::Internet.password(min_length: 8)

      fill_in 'Email', with: Faker::Internet.email
      fill_in 'Password', with: password
      fill_in 'Password confirmation', with: password

      click_on 'Sign up'
      expect(page).to have_content 'Welcome! You have signed up successfully'
    end

    scenario 'can not signup without password' do
      fill_in 'Email', with: Faker::Internet.email

      click_on 'Sign up'
      expect(page).to have_content "Password can't be blank"
      expect { User.count }.to_not change(User, :count)
    end

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
