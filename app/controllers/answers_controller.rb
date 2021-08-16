class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @answer = question.answers.new(answer_params)
    @answer.user = current_user

    return render 'questions/show', locals: {question: answer.question} unless answer.save

    redirect_to question_path(question)
  end

  def destroy
    redirect_to question_path(answer.question) unless current_user.author_of?(answer)

    answer.destroy
    redirect_to answer.question
  end

  private

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
