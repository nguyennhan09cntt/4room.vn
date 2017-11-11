var Privilege = function() {
    var handleBtnAdd = function() {
        $('#btn_add_new').on('click', function() {
            window.location.href = '/privilege/new?r=' + $(this).data('id');
        });
    }

    return {
        init: function() {
            handleBtnAdd();
        }
    }
}();
jQuery(document).ready(function() {
    Privilege.init();
});
