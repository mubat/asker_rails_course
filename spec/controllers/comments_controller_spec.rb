require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'POST #create' do

    context 'for Questions' do

      context 'by authenticated user' do
        before { login(user) }

        context 'with valid parameters' do

          it 'new Comment links to question' do
            expect do
              post :create, format: :js, params: {
                comment: attributes_for(:comment)
                           .merge({ commentable_type: question.class, commentable_id: question.id })
              }
            end.to change(question.comments, :count).by(1)
          end

          it 'renders template `create`' do
            post :create, format: :js, params: {
              comment: attributes_for(:comment)
                         .merge({ commentable_type: question.class, commentable_id: question.id })
            }
            expect(response).to render_template :create
          end

        end

        context 'with invalid parameters' do

          it 'don\'t saves a new invalid Comment' do
            expect do
              post :create, format: :js, params: {
                comment: attributes_for(:comment, :empty_body)
                           .merge({ commentable_type: question.class, commentable_id: question.id })
              }
            end.to_not change(Comment, :count)
          end

          it 'should render question `create` template' do
            post :create, format: :js, params: {
              comment: attributes_for(:comment, :empty_body)
                         .merge({ commentable_type: question.class, commentable_id: question.id })
            }
            expect(response).to render_template :create
          end

        end
      end

      context 'by unauthenticated user' do

        it 'should not create new answer' do
          expect do
            post :create, format: :js, params: {
              comment: attributes_for(:comment)
                         .merge({ commentable_type: question.class, commentable_id: question.id })
            }
          end.to_not change(Comment, :count)
        end

        it 'should return login page' do
          post :create, format: :js, params: {
            comment: attributes_for(:comment)
                       .merge({ commentable_type: question.class, commentable_id: question.id })
          }
          expect(response).to have_http_status 401
        end

      end
    end
  end

  context 'for Answers' do
    let!(:answer) { create(:answer, user: user) }

    context 'by authenticated user' do
      before { login(user) }

      context 'with valid parameters' do

        it 'new Comment links to question' do
          expect do
            post :create, format: :js, params: { comment: attributes_for(:comment, commentable: answer) }
          end.to change(answer.comments, :count).by(1)
        end

        it 'renders template `create`' do
          post :create, format: :js, params: { comment: attributes_for(:comment, commentable: answer) }
          expect(response).to render_template :create
        end
      end

      context 'with invalid parameters' do
        it 'don\'t saves a new invalid Comment' do
          expect do
            post :create, format: :js, params: { comment: attributes_for(:comment, :empty_body) }
          end.to_not change(Comment, :count)
        end

        it 'should render question `create` template' do
          post :create, format: :js, params: { comment: attributes_for(:comment, :empty_body) }
          expect(response).to render_template :create
        end

      end
    end

    context 'by unauthenticated user' do

      it 'should not create new answer' do
        expect do
          post :create, format: :js, params: { comment: attributes_for(:comment) }
        end.to_not change(Comment, :count)
      end

      it 'should return login page' do
        post :create, format: :js, params: { comment: attributes_for(:comment) }
        expect(response).to redirect_to new_user_session_path
      end

    end
  end
end
