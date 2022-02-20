require 'rails_helper'

RSpec.describe VotesController, type: :controller do

  describe 'DELETE #destroy' do
    let(:user) { create(:user) }
    let!(:answer) { create(:answer) }
    let!(:vote) { create(:vote, user: user, votable: answer) }

    context 'by authenticated user' do
      before { login(user) }

      context "by Vote's owner" do
        it 'can delete' do
          expect { delete :destroy, params: { id: vote }, format: :json }.to change(Vote, :count).by(-1)
        end

        it 'response with actual Votable rating' do
          delete :destroy, params: { id: vote }, format: :json
          parsed_body = JSON.parse(response.body)
          expect(parsed_body['rating']).to eq 0
        end

        it "returns status 'OK'" do
          delete :destroy, params: { id: vote }, format: :json
          expect(response).to have_http_status(:ok)
        end
      end

      context "of other user's Vote" do
        let!(:other_user_vote) { create(:vote) }

        it "can't delete" do
          expect { delete :destroy, params: { id: other_user_vote }, format: :json }.to_not change(Vote, :count)
        end

        it "returns status 'Forbidden'" do
          delete :destroy, params: { id: other_user_vote }, format: :json
          expect(response).to have_http_status(:forbidden)
        end

      end
    end

    context 'by unauthenticated user' do
      it "doesn't delete Vote" do
        expect { delete :destroy, params: { id: vote }, format: :json }.to_not change(Vote, :count)
      end

      it 'returns status "unauthorized"' do
        delete :destroy, params: { id: vote }, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
