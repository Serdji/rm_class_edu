module.exports = (nodes, ed) => {
  let input  = nodes.questionForm.querySelector('#question_title');
  let select = nodes.questionForm.querySelector('#question_tag_ids');

  // При закритие отчещаем форму
  tinymce.activeEditor.setContent('');
  input.value = '';
  input.classList.remove('_editor-ok', '_editor-error');
  ed.editorContainer.classList.remove('_editor-ok', '_editor-error');
  select.nextSibling.firstChild.classList.remove('_editor-ok', '_editor-error');
};
