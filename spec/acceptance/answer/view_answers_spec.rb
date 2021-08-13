require 'rails_helper'

feature "User can see answers on the question's view", "
  In order to find answer that need for me
  As an user
  I'd like to be able to see all answers of the question
" do

  given!(:question) { create(:question) }

  scenario "Can see answers on the question's view"
  scenario "Can see label that question doesn't has answers"
end

