require 'rails_helper'

feature 'User can signup', "
  In order to allow to ask questions
  As an unauthenticated user
  I'd like to be able signup
" do

  describe 'Unregistered user' do

    scenario 'can signup'

    scenario 'can not signup without password'

    scenario 'can not signup without login'

  end

  scenario 'Registered user can not signup'

  scenario 'Authenticated user can not signup again'

end
