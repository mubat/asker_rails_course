class QuestionsController < ApplicationController

  before_action :authenticate_user!, except: %w[index show]

  def index
    @questions = Question.all
  end

  def new; end

  def create
    question = current_user.questions.new(question_params)
    if question.save
      redirect_to question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def show
    @answer = question.answers.new
  end

  def edit; end

  def update
    if question.update(question_params)
      redirect_to @question
    else
      render :edit
    end
  end

  helper_method :question

  def destroy
    question.destroy
    redirect_to questions_path, notice: 'Your question successfully destroyed.'
  end

  private

  def question
    @question ||= params[:id] ? Question.find(params[:id]) : Question.new
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
