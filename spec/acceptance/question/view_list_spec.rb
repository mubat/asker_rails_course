require 'rails_helper'

feature 'User can view list of questions', '
  In order to see previously asked questions
  As an authenticated user
  I\'d like to be able to view list of questions
' do

  given!(:questions) { create_list(:question, 10) }

  scenario 'View list of questions' do
    visit questions_path
    questions.each do |question|
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end
  end
end
