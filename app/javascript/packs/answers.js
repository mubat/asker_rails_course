$(document).ready(function () {
    $('.edit-answer-link').on('click', function (event) {
        event.preventDefault();
        let _this = $(this);
        _this.hide();
        const answerId = _this.data('answerId');
        $(`form#edit-answer-${answerId}`).removeClass('hidden');
    });
});