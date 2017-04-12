// Show hide password block in the employee create/edit form
function employee_password_activate(checked) {
  $('.js-change-password').toggleClass('hide', !checked);
  $('.js-change-password input[type=password]').prop('disabled', !checked);
}
$(function() {
  $('#employee_change_password').on('change', function() {
    employee_password_activate($(this).prop('checked'));
  });
  employee_password_activate($('#employee_change_password').prop('checked'));
});
