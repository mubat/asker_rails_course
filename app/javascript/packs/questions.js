$(document).on('turbolinks:load', function () {
    $('.question-data').on('click', '.edit-question', function (event) {
        event.preventDefault();
        let _this = $(this);
        _this.addClass('hidden');        
        $(`form#form-edit-question`).removeClass('hidden');
 });
});