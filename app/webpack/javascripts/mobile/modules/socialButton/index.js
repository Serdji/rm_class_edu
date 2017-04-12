const { qs, qsa } = require('utils');

if (qs('.js-open-share')) {
  let nodes = {
    questionSocial: qs('.js-question-social'),
    commonSocial: qsa('.js-common-social'),
    openShare: qsa('.js-open-share')
  };

  // Добавляем CDN шарилок с нашим скриптом
  let script    = document.createElement('script');
  script.onload = require('./ramblerShare')(nodes);
  script.async  = true;
  script.src    = 'https://developers.rambler.ru/likes/widget.js';
  document.head.appendChild(script);
  require('./openShare')(nodes);
  require('./autoScroll')();
}
