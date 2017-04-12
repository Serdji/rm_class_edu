module.exports = (nodes, ed) => {

  nodes.inputQuestion.classList.add('_editor-error');
  nodes.selectQuestion.nextSibling.firstChild.classList.add('_editor-error');
  nodes.inputQuestion.classList.remove('_editor-ok');
  ed.editorContainer.classList.remove('_editor-ok');
  nodes.selectQuestion.nextSibling.firstChild.classList.remove('_editor-ok');
};
