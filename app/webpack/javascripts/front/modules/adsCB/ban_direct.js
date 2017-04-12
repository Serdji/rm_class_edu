const configAds = require('./configAds');

module.exports = (el, iter) => {
  let html = `<div class="baner">
                <div id="ban_direct_${iter}"></div>
              </div>`;
  el.insertAdjacentHTML('afterEnd', html);
  Adf.banner.sspScroll(`ban_direct_${iter}`, configAds.ban_direct.p, configAds.ban_direct.id);
};
