const { qs, qsa } = require('utils');
const Captcha     = require('captcha');

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
    popUpQuestion:qs ('.js-pop-up-question')
  };
  let captcha = new Captcha('.js-captcha-complaint', '.js-send-complaint');
  captcha.update();
  require('./setupCallbacks')(nodes);
  require('./openPopUp')(nodes);
  require('./closePopUp')(nodes);
  require('./sendComplaint')(nodes);
}
