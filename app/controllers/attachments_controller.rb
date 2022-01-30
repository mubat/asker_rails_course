class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    attachment.purge
  end

  private

  def attachment
    @attachment ||= ActiveStorage::Attachment.find(params[:id])
  end
end
