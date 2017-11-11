var Module = function() {
    var handleBtnAdd = function() {
        $('#btn_add_new').on('click', function() {
            window.location.href = '/module/new';
        });
    }

    return {
        init: function() {
            handleBtnAdd();
        }
    }
}();
jQuery(document).ready(function() {
    Module.init();
});
