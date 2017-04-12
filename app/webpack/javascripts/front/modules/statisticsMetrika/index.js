const { qs } = require('utils');

if (qs('.js-search')) {
  let nodes = {
    search: qs('.js-search')
  };
  require('./statisticsMetrika')(nodes);
}

