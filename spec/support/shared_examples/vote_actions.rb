require 'rails_helper'

RSpec.shared_examples "VoteActions" do
  describe 'PATCH #like' do
    describe 'like Answer' do
      it 'by authenticated user' do
        login(user)
        expect { patch :like, params: { id: resource } }.to change(Vote, :count).by(1)
      end

      it "by Answer's author" do
        login(resource_author)
        expect { patch :like, params: { id: resource } }.to_not change(Vote, :count)
        parsed_body = JSON.parse(response.body)
        expect(parsed_body['errors']).to include "User can't vote on his Answer"
      end

      it 'by unauthenticated user' do
        expect { patch :like, params: { id: resource } }.to_not change(Vote, :count)
        expect(response).to redirect_to new_user_session_path
      end

      it 'resource with JSON' do
        login(user)
        patch :like, params: { id: resource }, format: :js
        parsed_body = JSON.parse(response.body)
        expect(parsed_body['vote']['degree']).to eq 'like'
        expect(parsed_body['rating']).to eq 1
      end
    end
  end

  describe 'PATCH #dislike' do
    describe 'like Answer' do
      it 'by authenticated user' do
        login(user)
        expect { patch :dislike, params: { id: resource } }.to change(Vote, :count).by(1)
      end

      it "by Answer's author" do
        login(resource_author)
        expect { patch :dislike, params: { id: resource } }.to_not change(Vote, :count)
        parsed_body = JSON.parse(response.body)
        expect(parsed_body['errors']).to include "User can't vote on his Answer"
      end

      it 'by unauthenticated user' do
        expect { patch :dislike, params: { id: resource } }.to_not change(Vote, :count)
        expect(response).to redirect_to new_user_session_path
      end

      it 'resource with JSON' do
        login(user)
        patch :dislike, params: { id: resource }, format: :js
        parsed_body = JSON.parse(response.body)
        expect(parsed_body['vote']['degree']).to eq 'dislike'
        expect(parsed_body['rating']).to eq(-1)
      end
    end
  end

end