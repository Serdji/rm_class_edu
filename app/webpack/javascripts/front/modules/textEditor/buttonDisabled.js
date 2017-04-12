module.exports = (nodes) => {
  let editorText = tinymce.activeEditor.getContent();
  nodes.formButton.classList[editorText.length > 0 ? 'remove' : 'add']('_button-none');
};
