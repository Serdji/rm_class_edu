const configAds = require('./configAds');

module.exports = (el, index) => {
  let html = `<div class="baner">
                <div id="ban_100х240_${index}"></div>
              </div>`;
  el.insertAdjacentHTML('afterEnd', html);
  Adf.banner.sspScroll(`ban_100х240_${index}`, configAds.ban_100х240.p, configAds.ban_100х240.id);
};
