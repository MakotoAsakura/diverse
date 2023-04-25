
(function (doc) {
  'use strict';
  if (document.getElementById("admin-page")) return

  var brandLoadingTime = 3000,
    progressPercent = 0,
    progressBar;
  var $loadingWrap = document.getElementById('loading'),
    $progressLoading = $loadingWrap.querySelector('.progressLoading'),
    $messageLoading = $loadingWrap.querySelector('.loading-message');

  var progressLoading = function () {
    if (progressPercent >= 100) {
      clearInterval(progressBar);
    } else {
      progressPercent++;
      $progressLoading.style.width = progressPercent + '%';
    }
  }

  window.hideLoading = function () {
    // console.log('hide');
    progressPercent = 100;
    $progressLoading.style.width = progressPercent + '%';
    clearInterval(progressBar);
    $loadingWrap.classList.remove('loading');
    document.body.classList.remove('on-popup');
  }

  window.showLoading = function (loadingText) {
    //animation progress loading bar
    document.body.classList.add('on-popup');
    progressPercent = 0;
    $progressLoading.style.width = progressPercent + '%';
    // $messageLoading.innerHTML(loadingText);
    $loadingWrap.classList.add('loading');
    // clearInterval(progressBar);
    setTimeout(function () {
      progressBar = setInterval(progressLoading, 10);
    }, 300);
  }

  // showLoading();

  //document ready
  document.addEventListener('DOMContentLoaded', function() {
    var scrollPosition = document.documentElement.scrollTop || document.body.scrollTop;

    if (scrollPosition > 0) {
      document.body.classList.add('scrolling');
    } else {
      document.body.classList.remove('scrolling');
    }

    document.querySelectorAll('[data-carousel="swiper"]').forEach(function(obj, index) {
      var container		= obj.getAttribute('id'),
        slideItem = !obj.getAttribute('slide-item') || isNaN(obj.getAttribute('slide-item')) ? 3 : Number(obj.getAttribute('slide-item')),
        slideSpeed = !obj.getAttribute('slide-speed') || isNaN(obj.getAttribute('slide-speed')) ? 400 : Number(obj.getAttribute('slide-speed')),
        slideLoop = obj.getAttribute('slide-loop')==true? 'true':'false',
        slideDirection = obj.getAttribute('slide-direction') == 'vertical' ? 'vertical' : 'horizontal',
        slidecenteredSlides = obj.getAttribute('slide-centeredSlides')==true? 'true':'false',
        dataAutoplay= !obj.getAttribute('slide-autoplay') || isNaN(obj.getAttribute('slide-autoplay')) ? false : {
          delay: Number(obj.getAttribute('slide-autoplay')),
          disableOnInteraction: false,
        },
        swOption;

      if (!container) {
        obj.setAttribute('id', 'swiper-slider-'+index);
        container = 'swiper-slider-'+index;
      }
      swOption = {
        // Optional parameters
        direction: slideDirection,
        loop: slideLoop,
        speed: slideSpeed,
        slidesPerView: 1,
        spaceBetween: 20,
        centeredSlides: slidecenteredSlides,
        // If we need pagination
        pagination: {
          el: '#' + container + ' .swiper-pagination',
          clickable: true,
        },

        // Navigation arrows
        navigation: {
          nextEl: '#' + container + ' .swiper-button-next',
          prevEl: '#' + container + ' .swiper-button-prev',
        },
        breakpoints: {
          768: {
            slidesPerView: slideItem > 2 ? 2: 1
          },
          992: {
            slidesPerView: slideItem,
          },
        },
        // And if we need scrollbar
        // scrollbar: {
        //   el: '.swiper-scrollbar',
        // },
      };
      if (dataAutoplay) {
        swOption.autoplay = dataAutoplay;
      }
      var mySwiper = new Swiper('#' + container + ' .swiper-container', swOption);
    });

    var myCollapsible = document.getElementById('main-nav');
    if (myCollapsible) {
      myCollapsible.addEventListener('shown.bs.collapse', function () {
        document.body.classList.add('on-popup');
      });
      myCollapsible.addEventListener('hide.bs.collapse', function () {
        document.body.classList.remove('on-popup');
      });
    }

    //start: Horizontal Scroll with GSAP and ScrollMagic
    var jsSlideContainer = document.getElementById('js-slideContainer'),
      jsWrapper = document.getElementById('wrapper');
    if (jsSlideContainer && jsWrapper) {
      var titles = document.querySelectorAll('.section__content'),
        step = 100 / titles.length;
      TweenLite.defaultEase = Linear.easeNone;
      // console.log(step);
      var controller = new ScrollMagic.Controller();

      var horizontalSlide = new TimelineMax()
        // animate panels
        .to('#js-slideContainer', 1,   {x: '-'+ step*1 +'%'}, 'label1')
        .from(titles[1], 0.5, {opacity:1}, 'label1+=0.5')
        .to('#js-slideContainer', 1,   {x: '-'+ step*2 +'%'}, 'label2')
        .from(titles[2], 1, {opacity:1}, 'label2+=0.5')
        .to('#js-slideContainer', 1,   {x: '-'+ step*3 +'%'}, 'label3')
        .from(titles[3], 0.5, {opacity:1}, 'label3+=0.5')
        .to('#js-slideContainer', 1,   {x: '-'+ step*4 +'%'}, 'label4')
        .from(titles[4], 0.5, {opacity:1}, 'label4+=0.5')
        .to('#js-slideContainer', 1,   {x: '-'+ step*5 +'%'}, 'label5')
        .from(titles[5], 0.5, {opacity:1}, 'label5+=0.5')
      // .to("#js-slideContainer", 1,   {x: "-"+ step*6 +"%"}, "label6")
      // .from(titles[6], 0.5, {opacity:0}, "label6+=0.5");

      // create scene to pin and link animation
      new ScrollMagic.Scene({
        triggerElement: '#wrapper',
        triggerHook: 'onLeave',
        duration: '400%'
      })
        .setPin('#wrapper')
        .setTween(horizontalSlide)
        //.addIndicators() // add indicators (requires plugin)
        .addTo(controller);
    }
    //start: Horizontal Scroll with GSAP and ScrollMagic
  });

  //reset offsetHeight and scrollspy height
  var windowResize = function() {

  }

  window.addEventListener('resize', windowResize);

  window.addEventListener('scroll', function() {
    var scrollPosition = document.documentElement.scrollTop || document.body.scrollTop;
    // winHeight = $(window).height();


    if (scrollPosition > 0) {
      document.body.classList.add('scrolling');
    } else {
      document.body.classList.remove('scrolling');
    }
    // if ((scrollPosition >= winHeight-10) && $('body').hasClass('home-page')) {
    //     document.body.classList.add('scrolling-over');
    // } else {
    //     document.body.classList.remove('scrolling-over');
    // }
  });

  window.addEventListener('load', (event) => {
    setTimeout(function(){
      // hideLoading();
      // AOS.init();
      // $('#loading').removeClass('loading');
    }, 500);
    var elem = document.querySelector('.masonry-grid');
    // if ($('.masonry-grid-item')[0]) {
    //     var iso = new Isotope( elem, {
    //         // options
    //         itemSelector: '.masonry-grid-item'
    //     });
    // }
    document.querySelectorAll('.lazyload').forEach(function(obj, index) {
      obj.classList.add('loaded');
    });
    // bind filter button click
    // $('.filter-list').on( 'click', '.filter-group-item', function() {
    //     var filterValue = $( this ).attr('data-filter');
    //     // use filterFn if matches value
    //     filterValue = filterFns[ filterValue ] || filterValue;
    //     $grid.isotope({ filter: filterValue });
    // });
    // // change active class on buttons
    // $('.filter-group-item').each( function( i, buttonGroupItem ) {
    //     var $buttonGroupItem = $( buttonGroupItem );
    //     $buttonGroupItem.on( 'click', 'button', function() {
    //     $buttonGroupItem.find('.active').removeClass('active');
    //     $( this ).addClass('active');
    //     });
    // });
  });

  // $(function () {
  //     // $('.scrollify-page').scrollspy({
  //     //     target: '#main-nav',
  //     //     offset: 56
  //     // });

  //     $('.home-page #main-nav .navbar-nav').on('click', 'a', function (e) {
  //         // e.preventDefault();
  //         var $this = $(this),
  //             $target = $($this.attr('href'));
  //         // console.log($this.attr('href'));
  //         if ($target[0]) {
  //             e.preventDefault();
  //             if ($(window).width() < 992) {
  //                 $('#main-nav').collapse('hide');
  //             }
  //             $('html, body').animate({ scrollTop: $target.offset().top - $('#header').height()}, 700, function() {
  //                 // Animation complete.
  //                 $this.addClass('active')
  //                 $this.parent().siblings().find('> a').removeClass('active');
  //             });
  //         }
  //     });

  //     $(window).scroll(function(event){
  //         var scrollTop = $(this).scrollTop(),
  //             $brandsTop = $('#brands'),
  //             brandsTop = 0;
  //         if ($brandsTop[0]) {
  //             brandsTop = $brandsTop.offset().top;
  //             if ((scrollTop >= (brandsTop - 200)) && $('body').hasClass('home-page')) {
  //                 document.body.classList.add('scrolling-over');
  //             } else {
  //                 document.body.classList.remove('scrolling-over');
  //             }
  //         }
  //     });
  // });
  //window load
  // $(window).on('load', function () {
  //     // console.log(window.location.hash);
  //     // $.scrollify({
  //     //     // offset : 0,
  //     //     section : '.section-slide',
  //     //     setHeights: false,
  //     //     updateHash: false,
  //     //     before: function(){
  //     //         // console.log('next');
  //     //         // $('.section').removeClass('section-active')
  //     //         $('#home-banner h1.banner-title').addClass('inactive');
  //     //     },
  //     //     after:function(index, sections) {
  //     //         // console.log('next');
  //     //         var $current = $.scrollify.current();
  //     //         $current.addClass('section-active');
  //     //         // $('#home-banner h1.banner-title').addClass('inactive');
  //     //         $('#home-banner h1.banner-title').html($current.find('h1.banner-title').html());
  //     //         $('#home-banner h1.banner-title').removeClass('inactive');
  //     //     },
  //     // });
  //     if (window.location.hash) {
  //         var $target = $(window.location.hash);
  //         // $('.home-page #main-nav .navbar-nav a[href="'+ window.location.hash +'"]').click();
  //         // console.log($target[0]);
  //         // if ($target[0]) {
  //         //     $('html, body').animate({ scrollTop: $target.offset().top - $('#header').height()}, 700, function() {
  //         //         // Animation complete.
  //         //         // $this.addClass('active')
  //         //         // $this.parent().siblings().find('> a').removeClass('active');
  //         //     });
  //         // }
  //         setTimeout(function () {
  //             $('.home-page #main-nav .navbar-nav a[href="'+ window.location.hash +'"]').click();
  //         }, 300);
  //     }
  // var controller = new ScrollMagic.Controller({
  // 	globalSceneOptions: {
  // 		triggerHook: 'onLeave',
  // 		duration: '200%' // this works just fine with duration 0 as well
  // 		// However with large numbers (>20) of pinned sections display errors can occur so every section should be unpinned once it's covered by the next section.
  // 		// Normally 100% would work for this, but here 200% is used, as Panel 3 is shown for more than 100% of scrollheight due to the pause.
  // 	}
  // });

  // get all slides
  // var slides = document.querySelectorAll('section.section-ScrollMagic');

  // // create scene for every slide
  // for (var i=0; i<slides.length; i++) {
  //     var $slide = $(slides[i]);
  //     console.log($slide.find('.banner-sub-title').text());
  // 	new ScrollMagic.Scene({
  // 			triggerElement: slides[i],
  //             // offset: -250,
  // 		})
  // 		.setPin(slides[i], {pushFollowers: false})
  //         .setClassToggle(slides[i], 'visible') // add class toggle
  //         // .on("leave", function (event) {
  //         //     console.log("Scene" + i + " left.");
  //         // })
  // 		// .addIndicators() // add indicators (requires plugin)
  // 		.addTo(controller)
  //         // .on("enter", function (e) {
  //         //     console.log($slide.find('.banner-sub-title').text());
  //         //     $("#main-banner-item-last .banner-sub-title").text($slide.find('.banner-sub-title').text());
  //         //     // $("#main-banner-item-last .banner-title .text-animate").text($(slides[i]).find('.banner-title .text-animate').text());
  //         // });
  // }
  // var slides = document.querySelectorAll(".main-banner-content");
  // for (var i=0; i<slides.length; i++) {
  // 	new ScrollMagic.Scene({
  // 			triggerElement: slides[i],
  //             // offset: -250,
  // 		})
  // 		.setPin(slides[i], {pushFollowers: false})
  //         // .setClassToggle(slides[i], 'visible') // add class toggle
  //         // .on("leave", function (event) {
  //         //     console.log("Scene" + i + " left.");
  //         // })
  // 		// .addIndicators() // add indicators (requires plugin)
  // 		.addTo(controller);
  // }

  // var controller = new ScrollMagic.Controller();
  // $('.ScrollMagic-animation.ScrollMagic-ltr,.ScrollMagic-animation.ScrollMagic-rtl').each(function(index){
  //     var $this = $(this)
  //     new ScrollMagic.Scene({
  //         triggerElement: $this[0], // y value not modified, so we can use element as trigger as well
  //         offset: 250,												 // start a little later
  //         triggerHook: 0.9,
  //     })
  //     .setClassToggle($this[0], 'visible') // add class toggle
  //     // .addIndicators({name: "digit " + (index+1) }) // add indicators (requires plugin)
  //     .addTo(controller);
  // });
  // });
})(document)
