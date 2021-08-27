$(document).on('turbolinks:load', function () {
    $('.answers').on('click', '.edit-answer-link', function (event) {
        event.preventDefault();
        let _this = $(this);
        _this.hide();
        const answerId = _this.data('answerId');
        $(`form#edit-answer-${answerId}`).removeClass('hidden');
    });
});