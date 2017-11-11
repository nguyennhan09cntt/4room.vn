var PaymentIndex = {
    init: function () {
        $("#frmBillingAddress").validate({
            submitHandler: function (form) {
                form.submit();
            }
        });
    }
}

$(function () {
    //PaymentIndex.init();
    $('#btn-payment').click(function () {
        $('#frmBillingAddress').submit();
    });

    $('.product-color').change(function () {
        var value = $(this).val();
        var productProductOrderId = $(this).parents('tr').children('input.order-product-id').val();
        $.ajax({
            type: 'POST',
            url: '/product/update-color',
            data: {'value': value, 'id': productProductOrderId},
            dataType: 'html',
            success: function (data) {

            }
        });
    });

    $('.product-size').change(function () {
        var value = $(this).val();
        var productProductOrderId = $(this).parents('tr').children('input.order-product-id').val();
        $.ajax({
            type: 'POST',
            url: '/product/update-size',
            data: {'value': value, 'id': productProductOrderId},
            dataType: 'html',
            success: function (data) {

            }
        });
    });
    $('.cart-quantity').change(function () {
        var value = $(this).val();
        var productProductOrderId = $(this).parents('tr').children('input.order-product-id').val();
        var productPrice = $(this).parents('tr').children('input.product-paid-price').val();
        var productAmount = $(this).parents('tr').find('span.amount');
        $.ajax({
            type: 'POST',
            url: '/product/update-quantity',
            data: {'value': value, 'id': productProductOrderId, 'proPri': productPrice},
            dataType: 'json',
            success: function (data) {
                console.log(data.total_all);
                $(productAmount).html(data.total_all);
                $('#totalMoney').html(data.total_all);

            }
        });
    });
});