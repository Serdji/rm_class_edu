const { CONTACT_FORM_QUES,
        CONTACT_FORM_ANSWER
      }                  = require('./constants');
const { qs }             = require('utils');
const fieldInput         = require('./fieldFocus');
const sendContactForm    = require('./sendContactForm');
const filePickerCallback = require('./filePickerCallback');
const selectState        = require('./selectState');
const openSelectize      = require('./openSelectize');
const maxLengthText      = require('./maxLengthText');


if (qs('.js-contact-form-question')) {
  let nodes = {
    textQuestion: qs('.js-text-question'),
    blockDescription: qs('.js-block-description'),
    textDescription: qs('.js-text-description'),
    inputLabel: qs('.js-input-label'),
    inputPicture: qs('.js-input-picture'),
    sendButton: qs('.js-send-button'),
    textTheme: qs('.js-text-theme'),
    inputTheme: qs('.js-theme-input'),
    textSymbolsQuestion: qs('.js-text-symbols-question'),
    textSymbolsDescription: qs('.js-text-symbols-description'),
    textSymbolsTag: qs('.js-text-symbols-tag'),
    selectTag: qs('.js-select-tag'),
    form: qs('.js-form'),
    outputCounterQuestion: qs('.js-output-counter-question'),
    outputCounterDescription: qs('.js-output-counter-description'),
    outputCounterTag: qs('.js-output-counter-tag'),
    type: CONTACT_FORM_QUES
  };
  fieldInput(nodes);
  sendContactForm(nodes);
  filePickerCallback(nodes);
  selectState(nodes);
  openSelectize(nodes);
  maxLengthText(nodes, nodes.textQuestion, nodes.outputCounterQuestion, 147);
  maxLengthText(nodes, nodes.textDescription, nodes.outputCounterDescription, 4000);
  nodes.textQuestion.focus();

}

if (qs('.js-contact-form-answer')) {
  let nodes = {
    blockDescription: qs('.js-block-description'),
    textDescription: qs('.js-text-description'),
    inputLabel: qs('.js-input-label'),
    inputPicture: qs('.js-input-picture'),
    sendButton: qs('.js-send-button'),
    textSymbolsDescription: qs('.js-text-symbols-description'),
    questionForm: qs('.js-question-form'),
    outputCounterDescription: qs('.js-output-counter-description'),
    form: qs('.js-form'),
    type: CONTACT_FORM_ANSWER
  };
  fieldInput(nodes);
  sendContactForm(nodes);
  filePickerCallback(nodes);
  maxLengthText(nodes, nodes.textDescription, nodes.outputCounterDescription, 4000);
  nodes.textDescription.focus();
}
