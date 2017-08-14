module.exports = (el, index) => {

  let html = `<div class="baner">
                <div id="ban-content_${index}"></div>
              </div>`;
  el.insertAdjacentHTML('afterEnd', html);

  Adf.banner.showScroll(`ban-content_${index}`, {
    'p1': 'bvknm',
    'p2': 'emil',
    'pct': 'a',
    'puid49': `content${index}`
  });
};
