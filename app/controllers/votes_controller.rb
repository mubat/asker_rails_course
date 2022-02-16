class VotesController < ApplicationController
  before_action :authenticate_user!

  def destroy
    vote = Vote.find(params[:id])

    if current_user.author_of?(vote) && !current_user.author_of?(vote.votable)
      vote.destroy
      render json: { vote: vote }, status: :ok
    else
      render json: { errors: 'Forbidden' }, status: :forbidden
    end

  end
end
