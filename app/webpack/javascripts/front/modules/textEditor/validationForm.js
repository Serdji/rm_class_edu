module.exports = (nodes, ed, { title, body, tags }) => {
  if (!title) nodes.inputQuestion.classList.add('_editor-error');
  if (!tags) nodes.selectQuestion.nextSibling.firstChild.classList.add('_editor-error');

  if (title) nodes.inputQuestion.classList.add('_editor-ok');
  if (body) ed.editorContainer.classList.add('_editor-ok');
  if (tags) nodes.selectQuestion.nextSibling.firstChild.classList.add('_editor-ok');
};
