({
	scriptsLoaded: function(cmp, event, helper) {
        $(function() {
				
		    // initialize slick slider
		    var $slider = $('.slider').slick({
		        adaptiveHeight: true,
		        autoplay: true,
		        autoplaySpeed: 7000,
		        arrows: true,
		        prevArrow: '', // uncomment if arrows set to true
		        nextArrow: '<a href="javascript:;" class="slick-next"><i class="fal fa-chevron-right"></i></a>', // uncomment if arrows set to true
		        dots: true,
		        draggable: true,
		        fade: true,
		        variableWidth: true,
		        customPaging: function (slider, i) {
		            return '<button class="tab">' + $('.slick-thumbs li:nth-child(' + (i + 1) + ')').html() + '</button>';
		        }
		    });
		
			// go to slide
			$('[data-slick-slide]').click(function() {
				var $this = $(this);
				$('[data-slick-slide]').not($this).removeClass('active');
				$this.addClass('active');
				var clicked = $(this).data('slick-slide') - 1;
				$slider.slick('slickGoTo', clicked);
			});
		    
		});
		console.log('finish');
    },
    goToProfile : function(cmp, event, helper) {
		var userId = $A.get("$SObjectType.CurrentUser.Id");
        var urlEvent = $A.get("e.force:navigateToURL");
        var recordId = cmp.get("v.recordId");
        urlEvent.setParams({
          "url": "/profile/" + userId
        });
        urlEvent.fire();
    },
})