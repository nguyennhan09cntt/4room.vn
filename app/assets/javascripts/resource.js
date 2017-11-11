var Resource = function() {
    var handleBtnAdd = function() {
        $('#btn_add_new').on('click', function() {
            window.location.href = '/resource/new/?m=' + $('#btn_add_new').data('id');
        });
    }

    return {
        init: function() {
            handleBtnAdd();
        }
    }
}();
jQuery(document).ready(function() {
    Resource.init();
});
