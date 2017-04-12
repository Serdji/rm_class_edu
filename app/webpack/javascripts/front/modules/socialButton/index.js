const {qs, qsa} = require('utils');
module.exports = () => {
  if (qs('.js-open-share')) {
    let nodes = {
      questionSocial: qs('.js-question-social'),
      commonSocial: qsa('.js-common-social'),
      openShare: qsa('.js-open-share')
    };
    let script = document.createElement('script');
    // Добавляем CDN шарилок с нашим скриптом
    script.onload = require('./ramblerShare')(nodes);
    script.async  = true;
    script.src    = 'https://developers.rambler.ru/likes/widget.js';
    document.head.appendChild(script);
    require('./openShare')(nodes);
    require('./autoScroll')();
  }
};
