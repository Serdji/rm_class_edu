$(function() {
  if ($('.errors').length > 0) {
    $('.errors').fadeIn(3000).delay(1000).fadeOut(500, function() {
      $(this).hide();
    });
  }
});
