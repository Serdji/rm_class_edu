const { declOfNum } = require('utils'); // Склонятор
const count         = declOfNum()(['cимвол', 'cимвола', 'cимволов']);

module.exports = (node, ed, maxLength = 4000 ) => {
  let editorLengthText = tinymce.trim(tinymce.activeEditor.getBody().textContent).length;
  let remainderLength  = maxLength - editorLengthText;
  ed.editorContainer.classList.remove('_editor-error', '_editor-ok');
  if (node) {
    // Выводим сколько еще можно ввести симвалов
    let isNull = remainderLength > 0 ? remainderLength : 0;
    node.innerText = `Осталось ${isNull} ${count(isNull)}`;
    if (editorLengthText === 0) node.innerText = `Можно ввести ${maxLength} ${count(maxLength)}`;
  }
  // Если привышает задоного колличества симвалов останавливает собыите пичатать
  if (editorLengthText >= maxLength) {
    return false;
  }

  return remainderLength;
};
