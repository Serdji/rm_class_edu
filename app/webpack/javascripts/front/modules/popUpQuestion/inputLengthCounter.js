const { hasAtLeastChars, declOfNum } = require('utils'); // Склонятор
const count         = declOfNum()(['cимвол', 'cимвола', 'cимволов']);

module.exports = nodes => {
  let maxlength = 147;
  nodes.maxLengthInput.setAttribute('maxlength', maxlength);
  nodes.maxLengthCounter.innerText = `Можно ввести ${maxlength} ${count(maxlength)}`;
  nodes.maxLengthInput.addEventListener('keyup', (e) => {
    if (e.target.classList.contains('_editor-error')) {
      e.target.classList.remove('_editor-error');
      e.target.classList.add('_editor-ok');
    }

    let lengthSymbols   = e.target.value.length;
    let remainedSymbols = maxlength - lengthSymbols;

    nodes.maxLengthCounter.innerText = `Осталось ${remainedSymbols} ${count(remainedSymbols)}`;

    if (lengthSymbols === 0 || !hasAtLeastChars(e.target.value, 4)) {
      e.target.classList.add('_editor-error');
      e.target.classList.remove('_editor-ok');

      nodes.titleError.classList.remove('_hidden');
      nodes.maxLengthCounter.classList.add('_hidden');

      nodes.maxLengthCounter.innerText = `Можно ввести ${maxlength} ${count(maxlength)}`;
    } else {
      nodes.maxLengthCounter.classList.remove('_hidden');
      nodes.titleError.classList.add('_hidden');
    }
  });
};
