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
        if (gon.user_id === data.user_id) {
            return;
        }
        let answers_block = $(".answers");
        answers_block.find('.answers__empty').hide();
        answers_block.append(data.body);
    }
});