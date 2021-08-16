require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe 'POST #create - User can create new Answer' do
    it 'opens under question resource' do
      expect(post: "questions/#{question.id}/answers")
        .to route_to controller: 'answers', action: 'create', question_id: question.id.to_s
    end

    describe 'by authenticated user' do
      before { login(user) }

      context 'with valid parameters' do
        it 'new Answer links to question' do
          expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }
            .to change(question.answers, :count).by(1)
        end

        it 'redirects to Question\'s `show` view' do
          post :create, params: { question_id: question, answer: attributes_for(:answer) }
          expect(response).to redirect_to assigns(:question)
        end
      end

      context 'with invalid parameters' do
        it 'don\'t saves a new invalid Answer' do
          expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) } }
            .to_not change(Answer, :count)
        end
      end
    end

    describe 'by unauthenticated user' do

      it 'should not create new answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) } }
          .to_not change(Answer, :count)
      end

      it 'should return login page' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: question, user: user) }

    context 'by author' do
      before { login(user) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer, question_id: question }, format: :js }.to change(Answer, :count).by(-1)
      end

      it 'renders destroy' do
        delete :destroy, params: { id: answer, question_id: question }, format: :js
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'by other user' do
      let(:another_user) { create(:user) }

      before { login(another_user) }

      it "can't to destroy the answer" do
        expect { delete :destroy, params: { id: answer, question_id: question }}.not_to change(Answer, :count)
      end
    end

  end
end
