$('#questions-edit').each(function() {
  let parent = $(this);

  let $$ = function(element) {
    return parent.find(element);
  };

  let statesSelect = $$('._states-select');
  let warning = $$('.states-warning');

  if (statesSelect) {
    statesSelect.on('change', function() {
      if (this.selectize.getValue() === 'hidden') {
        warning.removeClass('hidden')
      } else {
        warning.addClass('hidden')
      };
    })
  }
})
