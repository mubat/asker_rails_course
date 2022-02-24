import consumer from "./consumer"

consumer.subscriptions.create("CommentsChannel", {
  connected() {
    let question = $('.question-data')

    if (!question) {
      return;
    }
    console.log('Connection result ', this.perform('subscribe', {
      commentable_id: question.data('question-id'),
      commentable_type: 'Question'
    }))
  },

  received(data) {
    if (gon.user_id === data.user_id) {
      return;
    }

    $(`#${data.commentable_type.toLowerCase()}-${data.commentable_id} .comments-list`).append(data.body);
  }
});
