const { qsa, qs }    = require('utils');
const iterAds        = require('./iterAds');
const callAds        = require('./callAds');
const sidebarIsAds   = require('./sidebarIsAds');
const autoScroll     = require('../socialButton/autoScroll');
const CONF           = require('./configAds');
let height240x400    = false;

let nodes = {
  banerSideba: qsa('.js-baner-sidebar'),
  questionsAds: qsa('.js-questions-ads'),
  tagAds: qsa('.js-tag-ads'),
  temyBanDirect: qs('.js-temy-ban-direct'),
  searchPagAds: qs('.js-search-pag-ads'),
  temyPagAds: qs('.js-temy-pag-ads'),
  rootBanDirect: qs('.js-root-ban-direct'),
  similarThemesAds: qs('.js-similar-themes-ads')
};
// Если включин AddBlock
sidebarIsAds(nodes);
let test = 1;
// Колбек отрабатывает после загрузке всей рекламмы
Begun.Autocontext.Callbacks.register({
  block: {
    draw() {
      // каждые 500ms проверяем банеры
      let intId = setInterval(() => {
        sidebarIsAds(nodes);
        let ban240x400 = qs('#ban_240x400 div[id^="begun_block"]');
        if (!height240x400 && ban240x400) {
          height240x400 = ban240x400.clientHeight;
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

callAds(CONF.ban_240x400);
callAds(CONF.native);
callAds(CONF.ban240x400_2nd);
callAds(CONF.billboard);
callAds(CONF.screen);
iterAds(nodes);

