$(function() {
  let sectionTypeSelect = $('#section_form_section_type');
  let stateSelect = $('#section_form_paragraph_state');

  function hideRows() {
    let nextRows = $('~ .row:not(.no-hidden-js)', sectionTypeSelect.parents('.row').first());

    if (sectionTypeSelect.val() === 'paragraphs') {
      nextRows.removeClass('hidden');
      stateSelect.chosen('destroy');
      stateSelect.chosen();
    } else {
      nextRows.addClass('hidden');
    }
  }
  sectionTypeSelect.on('change', function() { hideRows(); });
});
