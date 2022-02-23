class CommentsChannel < ApplicationCable::Channel
  def subscribe(data)
    commentable = data['commentable_type'].classify.constantize.find(data['commentable_id'])
    raise RecordNotFound unless commentable

    stream_for "#{data['commentable_type']}/#{commentable.id}/comments"
  end
end
