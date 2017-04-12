const renderBanFooter = require('./renderBanFooter');
const { qs }          = require('utils');
let pathname          = window.location.pathname;

// Проверяем страницу, если страница не тем выводим банер футер всегда
if (pathname !== '/temy/') {
  renderBanFooter();

} else if (qs('#ban_footer')) {

  // Проверяем наличе банера над кнопками пагинации
  let prevBanIsClass = qs('.pagination-wrapper').previousSibling.classList.contains('baner');
  if (!prevBanIsClass) renderBanFooter();
}
