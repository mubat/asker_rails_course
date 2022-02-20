$(document).on('turbolinks:load', function () {
    $('.answer-data,.question-data').on('ajax:success', '.vote-link', (event) => {
        let resourceContainer = $(event.delegateTarget);

        if (event.detail[0].vote.degree) {
            resourceContainer.find('.vote').addClass('hidden');
            resourceContainer.find('.vote-cancel').removeClass('hidden');
            resourceContainer.find('.vote-reset-link').attr('href', '/votes/' + event.detail[0].vote.id);
        }
        resourceContainer.find('.rating-value').text(event.detail[0].rating);

    }).on('ajax:error', '.vote-link,.vote-reset-link', (event) => {
        let alertData = event.detail[0];

        if (event.detail[0] instanceof Array) {
            let list = $('<ul></ul>');
            event.detail[0].forEach(message => { list.append($('<li>').text(message))});
            alertData = list;
        }

        $('.alert').html(alertData);
    }).on('ajax:success', '.vote-reset-link', (event) => {
        let resourceContainer = $(event.delegateTarget);

        resourceContainer.find('.vote-cancel').addClass('hidden');
        resourceContainer.find('.vote').removeClass('hidden');
        resourceContainer.find('.rating-value').text(event.detail[0].rating);
    })
});
