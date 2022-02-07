class LinksController < ApplicationController
  before_action :authenticate_user!
  
  def destroy
    link.destroy if current_user.author_of?(link.linkable)
  end

  private

  helper_method :link

  # @return [Link] target object
  def link
    @link ||= Link.find(params[:id])
  end

end
