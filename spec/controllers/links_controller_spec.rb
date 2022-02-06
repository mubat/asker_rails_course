require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  describe 'GET #destroy' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:link) { create(:link, linkable: create(:answer, question: question, user: user)) }

    describe 'Answer link' do
      describe 'by authenticated user' do
        it 'deletes link' do
          expect do
            delete :destroy, params: { id: link }, format: :js
            link.linkable.reload
          end.to change(Link, :count).by(-1)
        end

        it "doesn't delete link where not an answer's author"
      end

      describe 'by unauthenticated user' do
        it "doesn't delete link"
      end
    end
  end
end
