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
    answer.make_best if current_user.author_of?(answer.question)
    @question = answer.question
    render :update
  end


  def destroy
    answer.destroy if current_user.author_of?(answer)
  end

  private

  helper_method :question, :answer

  def answer_params
    params.require(:answer).permit(:body)
  end

  def question
    @question ||= Question.find(params[:question_id])
  end

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : Answer.new
  end
end
