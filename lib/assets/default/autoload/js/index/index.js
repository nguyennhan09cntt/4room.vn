/**
 * Created by Nhan on 7/4/2016.
 */


$(function(){
    $('#owl-carousel-slider').owlCarousel({
        slideSpeed: 300,
        paginationSpeed: 400,
        // pagination: owlSliderPagination,
        items: 1,
        navigation: true,
        navigationText: ['', ''],
        transitionStyle: 'goDown'
        // autoPlay: 4500
    });
});