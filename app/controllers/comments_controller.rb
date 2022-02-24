class CommentsController < ApplicationController
  before_action :authenticate_user!
  after_action :broadcast_comment, only: :create

  def create
    @comment = commentable.comments.new(comment_params)
    comment.user = current_user
    comment.save
  end

  private

  def broadcast_comment
    return unless comment.valid?

    question = comment.commentable.is_a?(Question) ? comment.commentable : comment.commentable.question
    CommentsChannel.broadcast_to "Question/#{question.id}/comments",
                                {
                                  user_id: current_user.id,
                                  commentable_type: comment.commentable.class.to_s,
                                  commentable_id: comment.commentable.id,
                                  body: ApplicationController.render(
                                    partial: 'comments/comment',
                                    locals: { comment: comment, current_user: nil }
                                  )
                                }
  end

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
