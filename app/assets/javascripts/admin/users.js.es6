$('#users-index').each(function() {
  let fileInput = $('#csv');

  fileInput.on('click', function() {
    $(this).val('');
  });

  fileInput.on('change', function() {
    let name = this.files[0].name;
    $(this).next().find('span').html(name);
  })
});
