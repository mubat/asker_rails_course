module VoteActions

  def like
    vote = resource.like(current_user)

    if vote.valid?
      render json: { vote: vote, rating: resource.rating }, status: :created
    else
      render json: { errors: vote.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def dislike
    vote = resource.dislike(current_user)

    if vote.valid?
      render json: { vote: vote, rating: resource.rating }, status: :created
    else
      render json: { errors: vote.errors.full_messages }, status: :unprocessable_entity
    end
  end

  ###############
  private

  def resource
    controller_name.classify.constantize.find(params[:id])
  end

end
