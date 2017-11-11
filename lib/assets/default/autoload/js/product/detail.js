/**
 * Created by Nhan on 4/25/2016.
 */
// Item quantity control (shopping cart)

$(function(){
    /*$(".cart-item-plus").click(function() {
        var currentVal = parseInt($(this).prev(".cart-quantity").val());

        if (!currentVal || currentVal == "" || currentVal == "NaN") currentVal = 0;

        $(this).prev(".cart-quantity").val(currentVal + 1);
    });

    $(".cart-item-minus").click(function() {
        var currentVal = parseInt($(this).next(".cart-quantity").val());
        if (currentVal == "NaN") currentVal = 0;
        if (currentVal > 0) {
            $(this).next(".cart-quantity").val(currentVal - 1);
        }
    });*/
    /*$(".fancybox").fancybox();*/
    /*$("#owl-demo").owlCarousel({

        navigation : true, // Show next and prev buttons
        slideSpeed : 300,
        paginationSpeed : 400,
        singleItem:true,
		items : 1

        // "singleItem:true" is a shortcut for:
        // items : 1,
        // itemsDesktop : false,
        // itemsDesktopSmall : false,
        // itemsTablet: false,
        // itemsMobile : false

    });*/
    /*$('#nivoSlider').nivoSlider({
        effect: 'boxRain',
        slices: 15,
        boxCols: 8,
        boxRows: 4,
        animSpeed: 500,
        pauseTime: 2000,
        startSlide: 0,
        directionNav: true,
        controlNav: true,
        controlNavThumbs: false,
        pauseOnHover: true,
        manualAdvance: false,
        prevText: 'Prev',
        nextText: 'Next',
        randomStart: false
    });*/

});
function QtyOnlyNumber(evt)
{
    var charCode = (evt.which) ? evt.which : event.keyCode
    if (charCode > 47 && charCode < 58)
        return true;

    alert("Số lượng phải lớn hơn 0!");
    return false;
}