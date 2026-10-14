jQuery(document).ready(function () {
    jQuery('.owl-slide').owlCarousel({
        items: 5,
        loop: true,
        margin: 20,
        autoplay: false,
        autoplayTimeout: 3000,
        autoplayHoverPause: true,
        dots: false,
        nav: true,
        responsive: {
            320: {
                items: 2,
                nav: true
            },
            460: {
                items: 3,
                nav: true
            },
            620: {
                items: 4,
                nav: true
            },
            1000: {
                items: 5,
                nav: true,
                loop: true
            }
        }

    });

    jQuery('.owl-slideview').owlCarousel({
        items: 1,
        loop: true,
        margin: 20,
        autoplay: false,
        autoplayTimeout: 3000,
        autoplayHoverPause: true,
        dots: true,
        nav: false,
        responsive: true

    });

    jQuery('.navbar-toggle').click(function () {
        jQuery('.nav-left').toggleClass("active");
        jQuery('body').toggleClass('mask');

    });

    jQuery('.nav-left .close').click(function () {
        jQuery('.nav-left').removeClass('active');
        jQuery('body').toggleClass('mask')
    });

    //iscCore.Popup();

})
