const { qs, qsa } = require('utils');

require('./fetchCurrentUser')();

// Вызываем nmp пакет TinyMCE
require('tinymce');
// Русифицируем TinyMCE
require('tinymceExtensions/langs/ru');
// Добавляем плагин математике
// require('tinymceExtensions/plugins/asciimath4');
// Подключаем плагин плейсхолдера
require('tinymceExtensions/plugins/placeholder');

let nodes = {};

if (qs('.js-editor-your-answer')) {
  nodes = {
    EDITOR_TYPE_ANSWER: true,
    formButton: qs('.js-form-button'),
    yourAnswer: qs('.js-your-answer'),
    form: qs('.js-form'),
    answers: qs('.js-quantity-answers'),
    allAnswers: qs('.js-all-answers'),
    blockAnswers: qsa('.js-block-answers'),
    answerTemplate: _.template(qs('.js-answer-template').innerHTML),
    login: qs('.js-login-your-answer'),
    registration: qs('.js-registration-ansver')
  };
  // Подсчет ответов
  require('./quantityAnswers')(nodes);
  // Вызов TinyMCE
  tinymce.init(require('./config')('.js-editor-your-answer', nodes));
}

if (qs('.js-editor-quantity')) {
  nodes = {
    EDITOR_TYPE_QUANTITY: true,
    sendQuestion: qs('.js-send-question'),
    counterEditor: qs('.js-max-length-counter-editor'),
    questionForm: qs('.js-question-form'),
    closeQuestion: qs('.js-close-pop-up-ques'),
    inputQuestion: qs('#question_title'),
    selectQuestion: qs('#question_tag_ids')
  };
  // Вызов TinyMCE
  tinymce.init(require('./config')('.js-editor-quantity', nodes));

  setTimeout(()=>require('./loginCallback')(), 3000);
}
