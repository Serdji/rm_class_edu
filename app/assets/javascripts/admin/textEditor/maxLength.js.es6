function editorMaxLength(ed, maxLengthCounter, maxLength = 4000 ) {
  let editorText       = tinymce.activeEditor.getContent({format: 'text'});
  let editorLengthText = editorText.length - 1;
  let remainderLength  = maxLength - editorLengthText;

  if (editorLengthText >= maxLength) {
    // Оставляем максимальное число символов
    tinymce.activeEditor.setContent(editorText.slice(0, maxLength));
  }

  if (maxLengthCounter) {
    let isNull = remainderLength > 0 ? remainderLength : 0;
    maxLengthCounter.innerText = `Осталось символов: ${isNull}`;
  }
};
