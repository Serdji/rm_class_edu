const { qs, qsa } = require('utils');
const tinymce     = require('tinymce');
const Captcha     = require('captcha');
require('./fetchCurrentUser')();

// ============== Плагины для TinyMCE =============== //

  // Русифицируем TinyMCE
  require('tinymceExtensions/langs/ru');
  // Добавляем плагин математике
  // require('tinymceExtensions/plugins/asciimath4');
  // Подключаем плагин плейсхолдера
  require('tinymceExtensions/plugins/placeholder');

  require('tinymce/plugins/paste');
  require('tinymce/plugins/link');
  require('tinymce/plugins/image');
  require('tinymce/plugins/autoresize');
  require('tinymce/themes/modern/theme');

// ================================================= //

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
    counterEditorAnswer: qs('.js-max-length-counter-editor-answer'),
    registration: qs('.js-registration-ansver')
  };
  // Подсчет ответов
  require('./quantityAnswers')(nodes);
  // Вызов TinyMCE
  tinymce.init(require('./config')('.js-editor-your-answer', nodes));
  let captcha = new Captcha('.js-captcha-answer');
  captcha.update();
}

if (qs('.js-editor-quantity')) {
  nodes = {
    EDITOR_TYPE_QUANTITY: true,
    sendQuestion: qs('.js-send-question'),
    counterEditorQues: qs('.js-max-length-counter-editor-ques'),
    questionForm: qs('.js-question-form'),
    closeQuestion: qs('.js-close-pop-up-ques'),
    inputQuestion: qs('#question_title'),
    selectQuestion: qs('#question_tag_ids'),
    titleLength: qs('.js-max-length-counter'),
    tagIdsLength: qs('.js-max-length-counter-select'),
    titleError: qs('.pop-up-question__title-error'),
    tagIdsError: qs('.pop-up-question__tag-ids-error')
  };
  // Вызов TinyMCE
  tinymce.init(require('./config')('.js-editor-quantity', nodes));
  setTimeout(()=>require('./loginCallback')(), 3000);
  let captcha = new Captcha('.js-captcha-question');
  captcha.update();
}
