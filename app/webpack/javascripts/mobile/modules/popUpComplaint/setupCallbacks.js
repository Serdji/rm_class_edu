const { declOfNum } = require('utils'); // Склонятор
const count         = declOfNum()(['cимвол', 'cимвола', 'cимволов']);

module.exports = nodes => {
  let lengthChecker = function() {
    let maxlength = 4000;
    let textareaLenght = nodes.textarea.value.length;
    let remainedTag = maxlength - textareaLenght;

    nodes.textarea.setAttribute('maxlength', maxlength);
    nodes.textareaCounter.innerText = `Осталось ${remainedTag} ${count(remainedTag)}`;
    if (this.value.length === 0) nodes.textareaCounter.innerText = `Можно ввести ${maxlength} ${count(maxlength)}`;

    if (this.value.length > 0) {
      this.classList.remove('_editor-error');
    } else {
      this.classList.add('_editor-error');
    }
  }

  let body = nodes.complaintForm['complaint[body]'];

  body.addEventListener('keyup', lengthChecker);
}
