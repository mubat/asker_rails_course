require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  describe 'DELETE #destory' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, files: [fixture_file_upload("#{Rails.root}/spec/rails_helper.rb")]) }

    describe 'Question attachment' do
      describe 'by authenticated user' do
        before { login(user) }

        it 'remove attached file from own 0question' do
          expect do
            delete :destroy, params: { id: question.files.first }
            question.reload
          end.to change(ActiveStorage::Attachment, :count).by(-1)
        end

        it 'should not remove attached file from not own question'
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
end
