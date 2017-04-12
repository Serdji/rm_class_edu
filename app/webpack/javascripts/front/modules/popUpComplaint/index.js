const { qs, qsa } = require('utils');

if (qs('.js-open-pop-up-complaint')) {
  let nodes = {
    buttonClose: qs('.js-close-pop-up-complaint'),
    buttonOpen: qsa('.js-open-pop-up-complaint'),
    buttonSend: qs('.js-send-complaint'),
    complaintForm: qs('.js-complaint-form'),
    complaintSuccess: qs('.js-complain-success'),
    popUpComplaint: qs('.js-pop-up-complaint'),
    textarea: qs('.js-textarea-complaint'),
    textareaCounter: qs('.js-max-length-counter-complaint'),
  };

  require('./setupCallbacks')(nodes);
  require('./openPopUp')(nodes);
  require('./closePopUp')(nodes);
  require('./sendComplaint')(nodes);
}
