module.exports = (el, index) => {

  let html = `<div class="baner">
                <div id="ban-listing_${index}"></div>
              </div>`;
  el.insertAdjacentHTML('afterEnd', html);

  Adf.banner.showScroll(`ban-listing_${index}`, {
    'p1': 'bvknm',
    'p2': 'emil',
    'pct': 'a',
    'puid49': `listing${index}`
  });
};
