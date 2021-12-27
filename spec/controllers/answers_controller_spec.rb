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
          expect { post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js } }
            .to change(question.answers, :count).by(1)
        end

        it 'redirects to Question\'s `show` view' do
          post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
          expect(response).to render_template :create
        end
      end

      context 'with invalid parameters' do
        it 'don\'t saves a new invalid Answer' do
          expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js }
            .to_not change(Answer, :count)
        end

        it 'should render question show template' do
          post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js
          expect(response).to render_template :create
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

  describe 'PATCH #update' do
    let!(:answer) { create(:answer, question: question, user: user, is_best: nil) }

    describe 'by authenticated user' do
      before { login(user) }

      context 'with valid attributes' do
        it 'changes answer attributes' do
          patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
          answer.reload
          expect(answer.body).to eq 'new body'
        end

        it 'renders update view' do
          patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
          expect(response).to render_template :update
        end
      end

      context 'with valid attributes' do
        it 'does not change answer attributes' do
          expect do
            patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
          end.to_not change(answer, :body)
        end

        it 'renders update view' do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
          expect(response).to render_template :update
        end
      end

      it 'updates by other user' do
        other_user = create(:user)
        login(other_user)

        patch :update, params: { id: answer, answer: {body: 'new body'} }, format: :js

        answer.reload
        expect(answer.body).to_not eq 'new body'
      end
    end

    describe 'make answer best' do
      it "by unauthenticated user" do
        patch :update, params: { id: answer, answer: {is_best: true} }, format: :js

        answer.reload
        expect(answer.is_best).to be_nil
      end
      
      it "by question's author" do
        login(user)

        patch :update, params: { id: answer, answer: {is_best: true} }, format: :js

        answer.reload
        expect(answer.is_best).to eq true
      end

      it "by other user"
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: question, user: user) }

    context 'by author' do
      before { login(user) }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer, question_id: question }, format: :js }.to change(Answer, :count).by(-1)
      end
    end

    context 'by other user' do
      let(:another_user) { create(:user) }

      before { login(another_user) }

      it "can't to destroy the answer" do
        expect { delete :destroy, params: { id: answer, question_id: question }, format: :js }.not_to change(Answer, :count)
      end
    end

  end
end
