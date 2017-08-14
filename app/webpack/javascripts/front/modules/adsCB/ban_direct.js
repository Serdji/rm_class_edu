const configAds = require('./configAds');

module.exports = (el, index) => {
  let html = `<div class="baner">
                <div id="ban_direct_${index}"></div>
              </div>`;
  el.insertAdjacentHTML('afterEnd', html);
  Adf.banner.sspScroll(`ban_direct_${index}`, configAds.ban_direct.p, configAds.ban_direct.id);
};
