$.ajaxSetup({ dataType: 'json' });
$(function() {
  $('.complaint-form-js')
    .on('ajax:success', function(e, data, status, xhr) {
      $('.flash-message').remove();
      Flash.add('success', data.success);
    }).on('ajax:error', function(e, data, status, xhr) {
      $('.flash-message').remove();
      Flash.add('danger', data.responseJSON.error);
    });
});