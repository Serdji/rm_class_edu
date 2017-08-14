const { hasAtLeastChars } = require('utils');

module.exports = (nodes, arrVal, lengthFrom = 0) => {

  let title        = nodes.textQuestion;
  let titleCounter = nodes.textSymbolsQuestion;
  let textTheme    = nodes.textTheme;
  let themeCounter = nodes.textSymbolsTag;
  let maxSymbols   = 4;


  if (arrVal) {
    // Проверяем наличие тем и выводим сообщение об ошибке
    textTheme.classList[arrVal.length === 0 ? 'add' : 'remove']('_error');
    textTheme.classList[arrVal.length === 0 ? 'remove' : 'add']('_focus');
    themeCounter.classList[arrVal.length === 0 ? 'add' : 'remove']('_error');

    themeCounter.classList[arrVal.length === 0 ? 'remove' : 'add']('grey');
  }
  if (!arrVal || !lengthFrom)  {
    // Если значене совпадет от значения с которого начинать проверку, вызываем регулярку
    let checkingReg = title.innerText.length >= lengthFrom ? !hasAtLeastChars(title.innerText, maxSymbols) : false;
    // Проверка длины текста от и до
    let checkingLengthTextFromAndTo = title.innerText.length >= lengthFrom && title.innerText.length < maxSymbols;

    // Проверяем текст в заголовке и выводем сообщение об ошибке
    title.classList[checkingLengthTextFromAndTo || checkingReg ? 'add' : 'remove']('_error');
    title.classList[checkingLengthTextFromAndTo || checkingReg ? 'remove' : 'add']('_focus');

    // Фокус в поле ввода при ошибке
    if(checkingLengthTextFromAndTo || checkingReg) title.focus();

    titleCounter.classList[checkingLengthTextFromAndTo || checkingReg ? 'add' : 'remove']('_error');
    titleCounter.classList[checkingLengthTextFromAndTo || checkingReg ? 'remove' : 'add']('grey');
  }
};
