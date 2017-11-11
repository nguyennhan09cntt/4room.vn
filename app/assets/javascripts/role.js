var Role = function() {
    var handleBtnAdd = function() {
        $('#btn_add_new').on('click', function() {
            window.location.href = '/role/new';
        });
    }

    return {
        init: function() {
            handleBtnAdd();
        }
    }
}();

jQuery(document).ready(function() {
    Role.init();
});
