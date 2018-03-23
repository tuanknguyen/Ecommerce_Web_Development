$(document).ready(function() {
  $('#myScrollspy > ul > li > a').click(function(){
        $('html, body').animate({
            scrollTop: $( $(this).attr('href') ).offset().top
        }, 500);
        return false;
    }); 
    $('body').scrollspy({ target: '#myScrollspy', 
    offset: 90})
});