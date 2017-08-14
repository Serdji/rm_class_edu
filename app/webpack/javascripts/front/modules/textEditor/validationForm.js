const { hasAtLeastChars } = require('utils');

module.exports = (nodes) => {
  let isValid = true;

  let titleElement = nodes.questionForm['question[title]'];
  let titleLength = titleElement.value.length;

  let tagIdsElement = nodes.selectQuestion.nextSibling.firstChild;
  let tagIdsLength = (nodes.selectQuestion.getAttribute('value') || '').length;

  if (titleLength === 0 || !hasAtLeastChars(titleElement.value, 4)) {
    titleElement.classList.add('_editor-error');
    titleElement.classList.remove('_editor-ok');

    nodes.titleLength.classList.add('_hidden');
    nodes.titleError.classList.remove('_hidden');
    isValid = false
  } else {
    nodes.titleLength.classList.remove('_hidden');
    nodes.titleError.classList.add('_hidden');
  }

  if (tagIdsLength === 0) {
    tagIdsElement.classList.add('_editor-error');
    nodes.tagIdsLength.classList.add('_hidden');
    nodes.tagIdsError.classList.remove('_hidden');
    isValid = false;
  } else {
    nodes.tagIdsLength.classList.remove('_hidden');
    nodes.tagIdsError.classList.add('_hidden');
  }

  return isValid;
};
