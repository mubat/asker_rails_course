import consumer from "./consumer"

consumer.subscriptions.create("AnswersChannel", {
    connected() {
        let question = $('.question-data')

        if (!question) {
            return;
        }
        this.perform('follow_question', { id: question.data('question-id') })
    },
});