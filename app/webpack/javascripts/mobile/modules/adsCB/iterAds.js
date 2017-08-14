const { qs, qsa, each } = require('utils');
const renderBanFooter   = require('./renderBanFooter');
const banContent        = require('./banContent');
const banListing        = require('./banListing');
const template          = require('./template');
const pathname          = window.location.pathname;

module.exports = () => {
  template();

  // Проскидываем рекламу в метки для вопросов
  each(qsa('.js-placement-ques'), (el, i) => {
    let index = i + 1;
    // Только на странице вопроса добавляем контентную рекламу, в остальных случию листинг
    if (qs('.js-page-question-ads')) {
      banContent(el, index);
    } else {
      banListing(el, index);
    }
  });

  let index;
  // Проскидываем рекламу в метки для тем
  each(qsa('.js-placement-tag'), (el, i) => {
    index = i + 1;
    banListing(el, index);
  });
  // Не выводим банер футер на странице тем, задать вопрос, ответить
  if (pathname !== '/temy/' && !qs('.js-contact-form-question') && !qs('.js-contact-form-answer')) {
    renderBanFooter();

  } else if (qs('#ban-footer')) {

    // Проверяем наличе банера над кнопками пагинации
    let prevBanIsClass = qs('.pagination-wrapper').previousSibling.classList.contains('baner');
    if (!prevBanIsClass) renderBanFooter();
  }
};
