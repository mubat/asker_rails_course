class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: %i[create]

  def create
    @answer = @question.answers.new(answer_params)

    return render 'questions/show', locals: {question: @answer.question} unless @answer.save

    redirect_to question_path(@question)
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def find_question
    @question = Question.find(params[:question_id])
  end
end
