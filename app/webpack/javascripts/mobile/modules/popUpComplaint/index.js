const { qs, qsa }            = require('utils');
const Captcha           = require('captcha');
const setupCallbacks    = require('./setupCallbacks');
const sendComplaint     = require('./sendComplaint');

if (qs('.js-pop-up-complaint')) {
  let nodes = {
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
  setupCallbacks(nodes);
  sendComplaint(nodes);
}
