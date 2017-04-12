const StickyBaner = require('stickyBaner');
const { qs }      = require('utils');
module.exports = () => {
  let nodes = {
    floatWrapper: qs('.js-float-wrapper'),
    floatContent: qs('.js-float-content'),
    footer: qs('footer')
  };

  let clonNodes = Object.assign({}, nodes);

  if (qs('.js-float-sidebar')) {
    // Класс объект который приклеевает банер
    new StickyBaner(Object.assign(clonNodes, {
      floatStartStop: qs('.js-float-start-stop'),
      floatAds: qs('.js-float-ad'),
      floatSidebar: qs('.js-float-sidebar')
    }));
  }

  if (qs('.js-float-left-sidebar')) {
    nodes = {
      floatStartStop: qs('.js-float-left-start-stop'),
      floatAds: qs('.js-left-float-ad'),
      floatSidebar: qs('.js-float-left-sidebar')
    };
    // Класс объект который приклеевает банер
    new StickyBaner(Object.assign(clonNodes, {
      floatStartStop: qs('.js-float-left-start-stop'),
      floatAds: qs('.js-left-float-ad'),
      floatSidebar: qs('.js-float-left-sidebar')
    }));
  }
};

