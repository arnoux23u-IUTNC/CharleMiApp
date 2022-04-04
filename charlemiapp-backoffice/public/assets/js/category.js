'use strict';

$('#category').on('change', function () {
    let input = $('#category-new');
    if ($(this).val() === "other") {
        input.show();
        input.prop('required', true);
    } else {
        input.hide();
        input.prop('required', false);
    }
});