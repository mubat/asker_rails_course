class AnswersChannel < ApplicationCable::Channel
  def follow_question(data)
    raise RecordNotFound if question = Question.find(data[:id])

    stream_for "question-#{question.id}"
  end
end
