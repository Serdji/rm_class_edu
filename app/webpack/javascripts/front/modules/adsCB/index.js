const iterAds        = require('./iterAds');
const stickingBaner  = require('../stickingBaner/index');
const sidebarIsAds   = require('./sidebarIsAds');
const autoScroll     = require('../socialButton/autoScroll');
const configAds      = require('./configAds');
const { qsa, qs }    = require('utils');
let height240x400    = false;
let intId;

let {
  ban_240x400,
  ban240x400_2nd,
  native,
  billboard,
  screen,
  context_240x200
} = configAds;

let nodes = {
  banerSideba: qsa('.js-baner-sidebar'),
  questionsAds: qsa('.js-questions-ads'),
  tagAds: qsa('.js-tag-ads'),
  temyBanDirect: qs('.js-temy-ban-direct'),
  searchPagAds: qs('.js-search-pag-ads'),
  temyPagAds: qs('.js-temy-pag-ads'),
  rootBanDirect: qs('.js-root-ban-direct'),
};
// Если включин AddBlock
sidebarIsAds(nodes);

// Колбек отрабатывает после загрузке всей рекламмы
Begun.Autocontext.Callbacks.register({
  block: {
    draw() {
      // каждые 500ms проверяем банеры
      intId = setInterval(() => {
        sidebarIsAds(nodes);
        let ban240x400 = qs('#ban_240x400 div[id^="begun_block"]');
        if (!height240x400 && ban240x400) {
          height240x400 = ban240x400.clientHeight;
          if (height240x400 !== 0 && height240x400 <= 400) {
            Adf.banner.sspScroll('Context_240x200', context_240x200.p, context_240x200.id);
          }
        }
      }, 500);
      // через 10 секунд перестаем проверять
      setTimeout(() => {
        clearInterval(intId);
        intId = false;
      }, 10000);
      setTimeout(() => {
        autoScroll();
        stickingBaner();
      }, 500);
    }
  },
});

Adf.banner.ssp('ban_240x400', ban_240x400.p, ban_240x400.id);
Adf.banner.sspScroll('native2', native.p, native.id);
Adf.banner.sspScroll('ban240x400_2nd', ban240x400_2nd.p, ban240x400_2nd.id);
Adf.banner.ssp('billboard', billboard.p, billboard.id );
Adf.banner.ssp('fullscreen', screen.p, screen.id);
iterAds(nodes);

