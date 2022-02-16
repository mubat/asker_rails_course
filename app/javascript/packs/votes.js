$(document).on('turbolinks:load', function () {
    let voteContainer = $('.vote-container');
    voteContainer.on('ajax:success', '.vote-link', (event) => {
        if (event.detail[0].degree) {
            voteContainer.find('.vote').addClass('hidden');
            voteContainer.find('.vote-cancel').removeClass('hidden');
            voteContainer.find('.vote-reset-link').attr('href', '/votes/' + event.detail[0].id);
        }
    }).on('ajax:error', '.vote-link,.vote-reset-link', (event) => {
        let alertData = event.detail[0];

        if (event.detail[0] instanceof Array) {
            let list = $('<ul></ul>');
            event.detail[0].forEach(message => { list.append($('<li>').text(message))});
            alertData = list;
        }

        $('.alert').html(alertData);
    }).on('ajax:success', '.vote-reset-link', (event) => {
        voteContainer.find('.vote-cancel').addClass('hidden');
        voteContainer.find('.vote').removeClass('hidden');
    })
});
