$(function() {
  $('.js-submit').on('click', function() {
    $(this).closest('form').submit();
  });
});
