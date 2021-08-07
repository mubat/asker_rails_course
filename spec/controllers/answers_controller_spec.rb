require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

  describe 'GET #new - User can open creation form of Answer' do

    it 'opens under question resource' do
      expect(get: "questions/#{question.id}/answers/new")
        .to route_to controller: 'answers', action: 'new', question_id: question.id.to_s
    end

    it 'render `new` form' do
      get :new, params: { question_id: question.id }
      expect(assigns(:answer)).to render_template :new
    end

  end

  describe 'GET #create - User can create new Answer' do
    it 'opens under question resource' do
      expect(post: "questions/#{question.id}/answers")
        .to route_to controller: 'answers', action: 'create', question_id: question.id.to_s
    end

    context 'with valid parameters' do
      it 'saves a new Answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }
          .to change(Answer, :count).by(1)
      end

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
      it 'don\'t saves a new invalid Answer'
      it 'reopen the `new` view'
    end
  end
end
