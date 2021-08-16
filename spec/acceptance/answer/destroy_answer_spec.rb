require 'rails_helper'

feature "Authenticated user can destroy his own answers on the question's view", "
  In order to remove not actual answer
  As an authenticated user
  I'd like to be able to my answers of the question
" do

  describe "Authenticated user" do
    scenario "Can destroy answers" do

    end

    scenario "Can't destroy not his own answer" do

    end
  end

  scenario "Unauthenticated user can't destroy answers" do

  end
end

