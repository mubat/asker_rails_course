require 'rails_helper'

feature 'User can login', "
  In order to allow to ask questions
  As an unauthenticated user
  I'd like to be able to login
" do

  describe 'Registered user' do

    scenario 'can login'

    scenario 'can not login with invalid password'

  end

  scenario 'Unregistered user can not login'

end
