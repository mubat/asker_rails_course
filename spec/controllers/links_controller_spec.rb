require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  describe 'GET #destroy' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }

    describe 'Answer link' do
      let!(:answer_link) { create(:link, linkable: create(:answer, question: question, user: user)) }

      describe 'by authenticated user' do
        before { login(user) }

        it 'deletes link' do
          expect do
            delete :destroy, params: { id: answer_link }, format: :js
            answer_link.linkable.reload
          end.to change(Link, :count).by(-1)
        end

        it "doesn't delete link where not an answer's author" do
          other_user = create(:user)
          other_author_answer = create(:answer, question: question, user: other_user)
          other_author_link = create(:link, linkable: other_author_answer)

          expect do
            delete :destroy, params: { id: other_author_link }, format: :js
          end.to_not change(Link, :count)
        end
      end

      describe 'by unauthenticated user' do
        it "doesn't delete link" do
          expect do
            delete :destroy, params: { id: answer_link }, format: :js
          end.to_not change(Link, :count)
        end
      end
    end

    describe 'Question link' do
      let!(:question_link) { create(:link, linkable: question) }

      describe 'by authenticated user' do
        before { login(user) }

        it 'deletes link' do
          expect do
            delete :destroy, params: { id: question_link }, format: :js
            question_link.linkable.reload
          end.to change(Link, :count).by(-1)
        end

        it "doesn't delete link where not an answer's author" do
          other_user = create(:user)
          other_author_question = create(:question, user: other_user)
          other_author_link = create(:link, linkable: other_author_question)

          expect do
            delete :destroy, params: { id: other_author_link }, format: :js
          end.to_not change(Link, :count)
        end
      end

      describe 'by unauthenticated user' do
        it "doesn't delete link"
      end
    end
  end
end
