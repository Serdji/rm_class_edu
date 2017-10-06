const { qs, qsa } = require('utils');
const locationComplaint = require('./locationComplaint');

if (qs('.js-ellipsis-pop-up')) {
  let nodes = {
    ellipsis: qsa('.js-ellipsis-pop-up'),
    locationComplaint: qsa('.js-location-complaint')
  };
  require('./showHidePopUp')(nodes);
  locationComplaint(nodes)
}
