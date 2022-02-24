class AnswersChannel < ApplicationCable::Channel
  def follow_answers_for_question(data)
    question = Question.find(data['id'])
    raise RecordNotFound unless question

    stream_for "question/#{question.id}/answers"
  end
end
