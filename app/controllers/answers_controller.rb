class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @answer = question.answers.new(answer_params)
    @answer.user = current_user

    answer.save
  end

  def update
    answer.update(answer_params) if current_user.author_of?(answer)
    @question = answer.question
  end

  def mark_best
    @question = answer.question

    if current_user.author_of?(answer)
      flash[:alert] = "You can't give a reward for yourself" if question.reward
    elsif current_user.author_of?(answer.question)
      answer.make_best
      flash[:notice] = "User #{answer.user.email} received a #{question.reward.name} reward" if question.reward
    end

    render :update
  end

  def like
    vote = answer.like(current_user)

    if vote.valid?
      render json: { vote: vote, rating: answer.rating }, status: :created
    else
      render json: { errors: vote.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def dislike
    vote = answer.dislike(current_user)

    if vote.valid?
      render json: { vote: vote, rating: answer.rating }, status: :created
    else
      render json: { errors: vote.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    answer.destroy if current_user.author_of?(answer)
  end

  private

  helper_method :question, :answer

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: %i[name url])
  end

  def question
    @question ||= Question.find(params[:question_id])
  end

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : Answer.new
  end
end
