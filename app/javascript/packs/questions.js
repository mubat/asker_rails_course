$(document).on('turbolinks:load', function () {
    $('.question-data').on('click', '.edit-question', function (event) {
        event.preventDefault();
        let _this = $(this);
        _this.addClass('hidden');
        $(`form#form-edit-question`).removeClass('hidden');
    });

    typeof loadGists !== 'undefined' && loadGists();
});

// source of these functions: https://dylanjh.com/blogs/4-how-to-embed-github-gists-with-turbolinks-in-rails
window.loadGists = function () {
    return $('.gist-container').each(function () {
        return loadGist($(this));
    });
};

window.loadGist = function ($gist) {
    let callbackName, script;
    callbackName = 'c' + Math.random().toString(36).substring(7);
    window[callbackName] = function (gistData) {
        let html;
        delete window[callbackName];
        html = '<link rel="stylesheet" href="' + encodeURI(gistData.stylesheet) + '"></link>';
        html += gistData.div;
        $gist.html(html);
        return script.parentNode.removeChild(script);
    };
    script = document.createElement('script');
    script.setAttribute('src', [
        $gist.data('src'), $.param({
            callback: callbackName,
            file: $gist.data('file') || ''
        })
    ].join('?'));
    return document.body.appendChild(script);
};
