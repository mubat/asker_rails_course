require 'rails_helper'

feature 'Author of the Question can mark best Answer', "
  In order to mark Answer that can help in Question
  As an author of Question
  I'd like to be able to mark best Answer
" do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user, is_best: nil) }
  given!(:best_answer) { create(:answer, question: question, user: user, is_best: true) }

  scenario "Unauthenticated User can't choose best Answer"

  describe 'Authenticated user' do
    background { login(user) }

    scenario 'can mark best Answer', js: true do
      visit question_path(question)

      within "#answer-#{answer.id}" do
        expect(page).to_not have_content 'Best answer'

        click_on 'Make answer best'

        expect(page).to have_text 'Best answer'
        expect(page).to_not have_text 'Make answer best'
        
        answer.reload
        expect(answer.is_best).to be_truthy
      end
    end
    
    scenario 'can mark other Answer as best (old best Answer stays regular)', js: true do
      old_best_answer = best_answer
      visit question_path(question)

      expect(find("#answer-#{old_best_answer.id}")).to have_content 'Best answer' 
      
      within "#answer-#{answer.id}" do
        expect(page).to_not have_text 'Best answer'

        click_on 'Make answer best'
        
        expect(page).to have_content 'Best answer'        
        expect(page).to_not have_link 'Make answer best'  
      end
      
      expect(find("#answer-#{old_best_answer.id}")).to_not have_content 'Best answer' 
    end

    scenario "can't choose best Answer if not an author" do
      other_user = create(:user)
      other_question = create(:question, user: other_user)
      other_answer = create(:answer, question: other_question, user: user, is_best: nil)

      visit question_path(other_question)

      within "#answer-#{other_answer.id}" do
        expect(page).to_not have_text 'Make answer best'
      end
    end
  end

end