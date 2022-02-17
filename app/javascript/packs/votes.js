$(document).on('turbolinks:load', function () {
    $('.answer-data').on('ajax:success', '.vote-link', (event) => {
        let answerContainer = $(event.delegateTarget);

        if (event.detail[0].vote.degree) {
            answerContainer.find('.vote').addClass('hidden');
            answerContainer.find('.vote-cancel').removeClass('hidden');
            answerContainer.find('.vote-reset-link').attr('href', '/votes/' + event.detail[0].vote.id);
        }
        answerContainer.find('.rating-value').text(event.detail[0].rating);

    }).on('ajax:error', '.vote-link,.vote-reset-link', (event) => {
        let alertData = event.detail[0];

        if (event.detail[0] instanceof Array) {
            let list = $('<ul></ul>');
            event.detail[0].forEach(message => { list.append($('<li>').text(message))});
            alertData = list;
        }

        $('.alert').html(alertData);
    }).on('ajax:success', '.vote-reset-link', (event) => {
        let answerContainer = $(event.delegateTarget);

        answerContainer.find('.vote-cancel').addClass('hidden');
        answerContainer.find('.vote').removeClass('hidden');
        answerContainer.find('.rating-value').text(event.detail[0].rating);
    })
});
