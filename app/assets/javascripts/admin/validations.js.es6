$(function() {
  $('[data-validate="number"]').each(function() {
    let input = $(this);
    let regexp = /[^\d]/gi;

    input.on('input', function() {
      $(this).val(input.val().replace(regexp, ''));
    });
  });
  $('[data-validate="isbn"]').each(function() {
    let input = $(this);
    let regexp = /[A-WY-ZА-ЯЁ]/gi;

    input.on('input', function() {
      $(this).val(input.val().replace(regexp, ''));
    });
  });
});
