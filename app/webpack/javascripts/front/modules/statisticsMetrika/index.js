const { qs } = require('utils');
const statisticsMetrika = require('./statisticsMetrika');

setTimeout(() => {
  if (window.yaCounter43407474 && qs('.js-search')) {
    let nodes = {
      search: qs('.js-search')
    };

    statisticsMetrika(nodes);
  }
}, 1000);
