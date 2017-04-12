$(function() {
  $('.js-grade-subject').on('change', function() {
    let url = window.location.href.replace(/\/(\d+)\/edit$/, '/' + $(this).val() + '/edit');
    window.location.href = url;
  });
});
