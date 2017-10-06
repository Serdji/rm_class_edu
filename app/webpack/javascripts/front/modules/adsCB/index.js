const { qsa, qs }    = require('utils');
const iterAds        = require('./iterAds');
const callAds        = require('./callAds');
const sidebarIsAds   = require('./sidebarIsAds');
const CONF           = require('./configAds');
const switch240x200  = require('./switch240x200');
const substrateNone = require('./substrateNone');

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
//Рекламма 240х200
switch240x200(nodes);
//Убираем подложку
substrateNone();


callAds(CONF.ban_240x400);
callAds(CONF.native);
callAds(CONF.ban240x400_2nd);
callAds(CONF.billboard);
callAds(CONF.screen);
iterAds(nodes);

