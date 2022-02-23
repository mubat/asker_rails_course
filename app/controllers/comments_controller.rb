class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @comment = commentable.comments.new(comment_params)
    comment.user = current_user
    comment.save
  end

  private

  helper_method :comment

  def comment
    @comment ||= Comment.find(params[:id])
  end

  def commentable
    @commentable ||= params[:comment][:commentable_type].classify.constantize.find(params[:comment][:commentable_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

end
