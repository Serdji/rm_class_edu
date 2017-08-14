const iterAbs         = require('./iterAds');
const { qs }          = require('utils');
const callAds         = require('./callAds');
const CONF = require('./configAds');

callAds(CONF.fullscreen);
callAds(CONF.inPage);
callAds(CONF.banRich);
callAds(CONF.topBanner);
iterAbs();

