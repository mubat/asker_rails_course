class QuestionsController < ApplicationController

  before_action :load_question, only: %w[show edit]

  def index
    @questions = Question.all
  end

  def new
    @question = Question.new
  end

  def show; end

  def edit; end

  def load_question
    @question = Question.find(params[:id])
  end
end
