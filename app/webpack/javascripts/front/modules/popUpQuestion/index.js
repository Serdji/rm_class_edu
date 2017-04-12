const { qs } = require('utils');

if (qs('.js-open-pop-up-ques')) {
  let nodes = {
    buttonOpen: qs('.js-open-pop-up-ques'),
    buttonClose: qs('.js-close-pop-up-ques'),
    popUpQuestion: qs('.js-pop-up-question'),
    maxLengthInput: qs('.js-max-length-input'),
    maxLengthCounter: qs('.js-max-length-counter'),
    maxLengthCounterSelect: qs('.js-max-length-counter-select'),
    input: qs('.js-max-length-input'),
    select: qs('.js-select-tag')
  };
  require('./openPopUp')(nodes);
  require('./closePopUp')(nodes);
  require('./selectState')(nodes);
  require('./inputLengthCounter')(nodes);
}
