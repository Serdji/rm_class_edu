const configAds = require('./configAds');

module.exports = (el, iter) => {
  let html = `<div class="baner">
                <div id="ban_100х240_${iter}"></div>
              </div>`;
  el.insertAdjacentHTML('afterEnd', html);
  Adf.banner.sspScroll(`ban_100х240_${iter}`, configAds.ban_100х240.p, configAds.ban_100х240.id);
};
