require 'rails_helper'

RSpec.describe RewardsController, type: :controller do
  let(:user) { create :user }

  describe 'GET #index' do
    describe 'by authenticated user' do
      before { login(user) }

      it 'renders index view' do
        get :index
        expect(response).to render_template :index
      end
    end

    it 'unauthenticated user redirects to login page' do
      get :index
      expect(response).to redirect_to(new_user_session_path)
    end
  end

end
