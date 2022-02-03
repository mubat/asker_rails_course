class QuestionsController < ApplicationController

  before_action :authenticate_user!, except: %w[index show]

  def index
    @questions = Question.all
  end

  def new
    question.links.new
  end

  def create
    @question = current_user.questions.new(question_params)
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
    update_status = current_user.author_of?(question) ? question.update(question_params) : false
    respond_to do |format|
      format.html  do 
        if update_status
          redirect_to @question
        else
          flash[:error] = "You are not an author of this question" unless current_user.author_of?(question)
          render :edit
        end
      end
      format.js { render :update }
    end
    
  end

  helper_method :question

  def destroy
    if current_user.author_of?(question)
      question.destroy
      flash[:notice] = 'Your question successfully destroyed.'
    else
      flash[:error] = "You don't has permission to delete question"
    end

    redirect_to questions_path
  end

  private

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: %i[name url])
  end
end
