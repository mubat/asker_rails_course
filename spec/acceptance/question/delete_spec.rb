require 'rails_helper'

feature 'User can destroy his own question', "
  In order to remove unnecessary question
  As a authenticated user
  I'd like to be able to destroy question created by me
" do

  describe 'Authenticated user' do

    scenario 'destroys his question' do
    end

    scenario 'can not destroy not his question' do
    end
  end

  scenario 'Unauthenticated user tries to destroy question' do
  end
end
