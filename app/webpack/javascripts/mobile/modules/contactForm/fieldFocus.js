module.exports = (nodes) => {

  if (nodes.textQuestion) nodes.textQuestion.addEventListener('focus', fieldFocus);
  if (nodes.textDescription) nodes.textDescription.addEventListener('focus', fieldFocus);
  if (nodes.textTheme) nodes.textTheme.addEventListener('focus', fieldFocus);
  if (nodes.textQuestion) nodes.textQuestion.addEventListener('blur', fieldBlur);
  if (nodes.textDescription) nodes.textDescription.addEventListener('blur', fieldBlur);
  if (nodes.textTheme) nodes.textTheme.addEventListener('blur', fieldBlur);

  // Вешаем или снимаем классы при фокусе

  function fieldFocus() {
    if (this.closest('.js-block-description')) nodes.blockDescription.classList.add('_focus');
    else this.classList.add('_focus');
  }

  function fieldBlur() {
    if (this.closest('.js-block-description')) nodes.blockDescription.classList.remove('_focus');
    else this.classList.remove('_focus');
  }
};
