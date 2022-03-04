'use strict';

$('#category').on('change', function () {
    if ($(this).val() === "other") {
        $('#category-new').show();
    } else {
        $('#category-new').hide();
    }
});