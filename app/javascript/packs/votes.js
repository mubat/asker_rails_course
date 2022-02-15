$(document).on('turbolinks:load', function () {
    $('.vote').on('ajax:success', '.vote-link', (event) => {
        if (event.detail[0].degree) {
            $(event.delegateTarget).addClass('hidden');
            console.log('Set hidden', event);
        }
    }).on('ajax:error', '.vote-link', (event) => {
        let alertData = event.detail[0];

        if (event.detail[0] instanceof Array) {
            let list = $('<ul></ul>');
            event.detail[0].forEach(message => { list.append($('<li>').text(message))});
            alertData = list;
        }

        $('.alert').html(alertData);
    })
});
