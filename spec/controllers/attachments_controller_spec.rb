require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }

  describe 'DELETE #destory' do
    let!(:question) do
      create(:question, user: user, files: [fixture_file_upload("#{Rails.root}/spec/rails_helper.rb")])
    end

    describe 'Question attachment' do
      describe 'by authenticated user' do
        before { login(user) }

        it 'remove attached file from own Question' do
          expect do
            delete :destroy, params: { id: question.files.first }, format: :js
            question.reload
          end.to change(ActiveStorage::Attachment, :count).by(-1)
        end

        it 'should not remove attached file from not own question' do
          other_user = create(:user)
          login(other_user)

          expect do
            delete :destroy, params: { id: question.files.first }, format: :js
            question.reload
          end.to_not change(ActiveStorage::Attachment, :count)
        end
      end
    end

    describe 'by unauthenticated user' do
      it 'should not remove attached file from question' do
        expect do
          delete :destroy, params: { id: question.files.first }
          question.reload
        end.to_not change(ActiveStorage::Attachment, :count)
      end
    end
  end

  describe 'Answer attachment' do
    let!(:question) { create(:question, user: user) }
    let!(:answer) do
      create(:answer, question: question, user: user,
             files: [fixture_file_upload("#{Rails.root}/spec/rails_helper.rb")])
    end

    describe 'by authenticated user' do
      before { login(user) }

      it 'remove attached file from own Answer' do
        expect do
          delete :destroy, params: { id: answer.files.first }, format: :js
          answer.reload
        end.to change(ActiveStorage::Attachment, :count).by(-1)
      end

      it 'should not remove attached file from not own Answer'

    end

    describe 'by unauthenticated user' do
      it 'should not remove attached file from question' do
        expect do
          delete :destroy, params: { id: answer.files.first }, format: :js
          answer.reload
        end.to_not change(ActiveStorage::Attachment, :count)
      end
    end
  end
end
