const { qs, qsa } = require('utils');

if (qs('.js-hash-tags')) {
  let nodes = {
    hashTags: qsa('.js-hash-tags')
  };
  require('./buttonOpenTags')(nodes);
  require('./openTags');
}
