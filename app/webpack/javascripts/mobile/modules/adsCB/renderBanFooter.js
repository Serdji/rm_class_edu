const callAds = require('./callAds');
const { banFooter } = require('./configAds');

module.exports = () => {
  callAds(banFooter);
};
