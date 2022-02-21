import consumer from "./consumer"

consumer.subscriptions.create("AnswersChannel", {
    connected() {
        let question = $('.question-data')

        if (!question) {
            return;
        }
        console.log('Connection result ', this.perform('follow_answers_for_question', { id: question.data('question-id') }))
    },
    received(data) {
        console.log('Received', data)
    }
});