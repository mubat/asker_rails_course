require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }

    before { get :index }

    it 'populate an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end
    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'renders show view' do
      expect(assigns(:question)).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(user) }

    before { get :new }

    it 'renders new view' do
      expect(assigns(:question)).to render_template :new
    end

    it 'show form for Links' do
      expect(assigns(:question).links.first).to be_a_new(Link)
    end
  end

  describe 'GET #edit' do
    before { login(user) }

    before { get :edit, params: { id: question } }

    it 'renders edit view' do
      expect(assigns(:question)).to render_template :edit
    end
  end

  describe 'POST #create' do
    before { login(user) }
    let(:last_question) { Question.order(:created_at).last }

    context 'with valid attributes' do

      it 'saves a new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
      end
      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to question_path(last_question)
      end

      it "should set current user question's owner" do
        post :create, params: { question: attributes_for(:question) }
        expect(last_question.user).to eq user
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    let!(:question_with_file) { create(:question, user: user, files: [fixture_file_upload("#{Rails.root}/spec/rails_helper.rb")]) }

    before { login(question.user) }

    context 'with valid attributes' do
      it 'assigns the requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question) }
        expect(assigns(:question)).to eq question
      end
      it 'changes question attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }
        question.reload

        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'add new attached file to question' do
        expect {
          patch :update,
                params: { id: question_with_file, question: { files: [fixture_file_upload("#{Rails.root}/spec/spec_helper.rb")] } },
                format: :js
          question.reload
        }.to change(ActiveStorage::Attachment, :count).by(1)
      end

      it 'redirects to updated question' do
        patch :update, params: { id: question, question: attributes_for(:question) }
        expect(response).to redirect_to :question
      end

      it 'allows to update via JS' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js
        question.reload

        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end
    end
    context 'with invalid attributes' do
      before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) } }

      it 'does not change question' do
        question.reload

        expect(question.title).to eq 'MyString'
        expect(question.body).to eq 'MyText'
      end

      it 're-renders edit view' do
        expect(response).to render_template :edit
      end
    end

    context 'other user' do
      let(:other_user) { create(:user) }
      before { login(other_user) }

      it "can't edit question" do
        before_title = question.title
        before_body = question.body
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' } }, format: :js

        question.reload
        expect(question.title).to eq before_title
        expect(question.body).to eq before_body
      end
    end
  end

  describe 'DELETE #destory' do
    let!(:question) { create(:question, user: user) }
    let!(:another_question) { create :question }

    describe 'by authenticated user' do
      before { login(user) }

      describe 'for own question' do
        it 'deletes the question' do
          expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
        end

        it 'redirects to index' do
          delete :destroy, params: { id: question }
          expect(response).to redirect_to questions_path
        end
      end

      describe 'for another`s question' do
        it 'should not delete' do
          expect { delete :destroy, params: { id: another_question } }.not_to change(Question, :count)
          expect(Question).to exist(another_question.id)
        end
      end
    end

    describe 'by unauthenticated user' do
      it 'can not delete question' do
        expect { delete :destroy, params: { id: question } }.not_to change(Question, :count)
        expect(Question).to exist(question.id)
      end
    end
  end

  let(:resource_author) { question.user }
  let(:resource) { question }
  it_behaves_like 'VoteActions'

end
