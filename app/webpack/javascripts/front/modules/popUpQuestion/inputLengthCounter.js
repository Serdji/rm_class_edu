const { declOfNum } = require('utils'); // Склонятор
const count         = declOfNum()(['cимвол', 'cимвола', 'cимволов']);

module.exports = nodes => {
  let maxlength = 147;
  nodes.maxLengthInput.setAttribute('maxlength', maxlength);
  nodes.maxLengthCounter.innerText = `Можно ввести ${maxlength} ${count(maxlength)}`;
  nodes.maxLengthInput.addEventListener('keyup', (e) => {
    e.target.classList.remove('_editor-error', '_editor-ok');
    let lengthSymbols   = e.target.value.length;
    let remainedSymbols = maxlength - lengthSymbols;
    nodes.maxLengthCounter.innerText = `Осталось ${remainedSymbols} ${count(remainedSymbols)}`;
    if (lengthSymbols === 0 ) nodes.maxLengthCounter.innerText = `Можно ввести ${maxlength} ${count(maxlength)}`;
  });
};
