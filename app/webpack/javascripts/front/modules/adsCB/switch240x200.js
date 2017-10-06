const { qs } = require('utils');
const callAds        = require('./callAds');
const sidebarIsAds   = require('./sidebarIsAds');
const autoScroll     = require('../socialButton/autoScroll');
const CONF           = require('./configAds');
let height240x400    = false;

module.exports = (nodes) => {
  // Колбек отрабатывает после загрузке всей рекламмы
  Begun.Autocontext.Callbacks.register({
    block: {
      draw() {
        // каждые 500ms проверяем банеры
        let intId = setInterval(() => {
          sidebarIsAds(nodes);
          let ban240x400 = qs('#ban_240x400 div[id^="begun_block"]');
          // Проверяем наличие банера
          if (!height240x400 && ban240x400) {
            // Берем его высоту
            height240x400 = ban240x400.clientHeight;
            // Если высота меньше чем 400 выводим баент 240x400
            if (height240x400 !== 0 && height240x400 <= 400) {
              callAds(CONF.context_240x200);
            }
          }
        }, 500);
        // через 10 секунд перестаем проверять
        setTimeout(() => {
          clearInterval(intId);
        }, 10000);
        setTimeout(() => {
          autoScroll();
        }, 500);
      }
    },
  });
};
