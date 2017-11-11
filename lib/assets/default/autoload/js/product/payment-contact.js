var PaymentContact= {
    init: function () {
        $("#frmBillingAddress").validate({
            submitHandler: function (form) {
                form.submit();
            }
        });
    }
}

$(function () {
    PaymentContact.init();

});