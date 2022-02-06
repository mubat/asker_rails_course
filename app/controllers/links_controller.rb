class LinksController < ApplicationController
  def destroy
    link.destroy
  end

  private

  # @return [Link] target object
  def link
    @link ||= Link.find(params[:id])
  end

end
