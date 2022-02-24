class AnswersController < ApplicationController
  include VoteActions

  before_action :authenticate_user!

  after_action :publish_answer, only: :create

  def create
    @answer = question.answers.new(answer_params)
    @answer.user = current_user
    @comment = current_user.comments.new

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

  def destroy
    answer.destroy if current_user.author_of?(answer)
  end

  private

  def publish_answer
    return unless answer.valid?
    AnswersChannel.broadcast_to "question/#{answer.question.id}/answers",
                                {
                                  user_id: current_user.id,
                                  body: ApplicationController.render(
                                    partial: 'answers/answer',
                                    locals: { answer: answer, question: question, current_user: nil }
                                  )
                                }
  end

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
