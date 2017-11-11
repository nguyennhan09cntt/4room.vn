var Component = function() {

    var handleDatePickers = function() {

        if (jQuery().datepicker) {
            $('.date-picker').datepicker({
                rtl: App.isRTL(),
                orientation: "left",
                autoclose: true
            });
            //$('body').removeClass("modal-open"); // fix bug when inline picker is used in modal
        }

        /* Workaround to restrict daterange past date select: http://stackoverflow.com/questions/11933173/how-to-restrict-the-selectable-date-ranges-in-bootstrap-datepicker */

        // Workaround to fix datepicker position on window scroll
        $(document).scroll(function() {
            $('#form_modal2 .date-picker').datepicker('place'); //#modal is the id of the modal
        });
    }

    var handleShowMenu = function() {
        $('li.module').removeClass('active');        
        var current = $('ul#menu').find('a.current');        
        if (current) {
            var module = current.closest('li.module');
            if (module) {
                module.addClass('active');
                module.addClass('open');
                var resource = current.closest('li.resource');
                if (resource) {
                    resource.addClass('open');
                    resource.closest('span.arrow').addClass('open');
                    resource.find('span.arrow').addClass('open');
                    if (current.closest('.sub-menu')[0])
                        current.closest('.sub-menu')[0].style.display = 'block';
                }
            }
        }
    }

    return {
        //main function to initiate the module
        init: function() {
            handleDatePickers();
            handleShowMenu();
        }
    };

}();

jQuery(document).ready(function() {
    Component.init();
});
