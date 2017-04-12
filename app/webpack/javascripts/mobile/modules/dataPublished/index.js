const { qs, qsa } = require('utils');
if (qs('.js-data-published')) {
  let nodes = {
    dataPublished: qsa('.js-data-published')
  };
  require('dataPublished')(nodes);
}
