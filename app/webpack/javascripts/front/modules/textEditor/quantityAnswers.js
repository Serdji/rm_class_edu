module.exports = nodes => {
  let answers = nodes.blockAnswers.length;
  if (answers > 0) nodes.answers.closest('.question-common__up-title').classList.remove('_hidden');
  nodes.answers.innerHTML = answers;
};
