function flyToElement(flyer, flyingTo) {
    var $func = $(this);
    var divider = 6;
    var flyerClone = $(flyer).clone();
    $(flyerClone).css({position: 'absolute', top: $(flyer).offset().top + "px", left: $(flyer).offset().left + "px", opacity: 1, 'z-index': 100000});
    $('body').append($(flyerClone));
    var gotoX = $(flyingTo).offset().left + ($(flyingTo).width() / 2) - ($(flyer).width()/divider)/2;
    var gotoY = $(flyingTo).offset().top + ($(flyingTo).height() / 2) - ($(flyer).height()/divider)/2;
     
    $(flyerClone).animate({
        opacity: 0.4,
        left: gotoX,
        top: gotoY,
        width: $(flyer).width()/divider,
        height: $(flyer).height()/divider
    }, 700,
    function () {
        $(flyingTo).fadeOut('fast', function () {
            $(flyingTo).fadeIn('fast', function () {
                $(flyerClone).fadeOut('fast', function () {
                    $(flyerClone).remove();
                });
            });
        });
    });
	
}
$(document).ready(function(){
    	
		$('button#addtocart').on('click',function(){
        //Select item image and pass to the function
        
        var currentIndex = $('div.owl-page.active').index();
        
        var itemImg = $('.overlay-container.overlay-visible').find('img:visible').eq(currentIndex);
        flyToElement($(itemImg), $('.icon-basket-1').not(':hidden'));
        
        
    });
});
