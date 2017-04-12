const { qs, qsa } = require('utils');
if (qs('.js-ellipsis-pop-up')) {
  let nodes = {
    ellipsis: qsa('.js-ellipsis-pop-up')
  };
  require('./showHidePopUp')(nodes);
}
