require 'rails_helper'

feature "Authorized user can add answer on the question's view", "
  In order to give answers
  As an authenticated user
  I'd like to be able to add my answer to the question that I see
" do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    background do
      login(user)

      visit question_path(question)
    end

    scenario 'Can add a new answer', js: true do
      fill_in 'Answer', with: 'Test answer'
      click_on 'Answer it'

      expect(current_path).to eq question_path(question)
      expect(page).to have_content 'Test answer'
    end

    scenario "Can't add an empty answer" do
      click_on 'Answer it'

      expect(current_path).to eq question_path(question)
      expect(page).to have_content "Answer can't be blank"
    end

    scenario 'Can add a new answer with attached files', js: true do
      fill_in 'Answer', with: 'Test answer'
      attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

      click_on 'Answer it'

      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_content 'Test answer'
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    context 'multiple sessions', js: true do
      describe 'Answer appears' do
        scenario 'for authorized user' do
          Capybara.using_session('watcher') do
            visit question_path(question)
          end

          Capybara.using_session('creator') do
            login(user)
            visit question_path(question)

            within '.new-answer' do
              fill_in 'Answer', with: 'Test answer'
              attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
            end

            click_on 'Answer it'

            within '.answers' do
              expect(page).to have_no_content 'Still no answer here'
              expect(page).to have_content 'Test answer'
              expect(page).to have_link 'rails_helper.rb'
              expect(page).to have_link 'spec_helper.rb'
            end
          end

          Capybara.using_session('watcher') do
            within '.answers' do
              save_screenshot 'answer_session.png'
              expect(page).to have_no_content 'Still no answer here'
              expect(page).to have_content 'Test answer'
              expect(page).to have_link 'rails_helper.rb'
              expect(page).to have_link 'spec_helper.rb'
            end
          end
        end

        scenario 'for unauthorized user' do
          Capybara.using_session('creator') do
            login(user)
            visit question_path(question)
          end

          Capybara.using_session('watcher') do
            visit question_path(question)
          end

          Capybara.using_session('creator') do
            within '.new-answer' do
              fill_in 'Answer', with: 'Test answer'
              attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
            end

            click_on 'Answer it'

            within '.answers' do
              expect(page).to have_content 'Test answer'
            end
          end

          Capybara.using_session('watcher') do
            within '.answers' do
              expect(page).to have_content 'Test answer'
              expect(page).to have_link 'rails_helper.rb'
              expect(page).to have_link 'spec_helper.rb'
            end
          end
        end

        scenario "for Question's author with link 'Make best'" do
          Capybara.using_session('creator') do
            login(user)
            visit question_path(question)
          end

          Capybara.using_session('question-owner') do
            login(question.user)
            visit question_path(question)
          end

          Capybara.using_session('creator') do
            within '.new-answer' do
              fill_in 'Answer', with: 'Test answer'
            end

            click_on 'Answer it'

            within '.answers' do
              expect(page).to have_content 'Test answer'
            end
          end

          Capybara.using_session('question-owner') do
            within '.answers' do
              expect(page).to have_content 'Test answer'
              expect(page).to_not have_link 'Edit'
              expect(page).to_not have_link 'Delete'
            end
          end
        end
      end

      scenario "Answer doesn't appears on other Questions" do
        Capybara.using_session('creator') do
          login(user)
          visit question_path(question)
        end

        Capybara.using_session('watcher') do
          visit question_path(create(:question))
        end

        Capybara.using_session('creator') do
          within '.new-answer' do
            fill_in 'Answer', with: 'Test text123-./'
            click_on 'Answer it'
          end
        end

        Capybara.using_session('other_question') do
          expect(page).not_to have_content 'Test text123-./'
        end
      end
    end
  end

  scenario "Can't add a new answer" do
    visit question_path(question)
    click_on 'Answer it'

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
