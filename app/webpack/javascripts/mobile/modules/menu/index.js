const { qs, qsa } = require('utils');
if (qs('.js-menu')) {
  let nodes = {
    buttonMenu: qs('.js-button-menu'),
    menu: qs('.js-menu'),
    menuCurtain: qs('.js-menu-curtain'),
    swPoints: qsa('.js-sw-points')

  };
  require('./openMenu')(nodes);
  require('./closeMenu')(nodes);
  require('./switchingPointsMenu')(nodes);
}

