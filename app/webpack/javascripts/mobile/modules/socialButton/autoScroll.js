const SweetScroll = require('sweet-scroll');

module.exports = () => {
  const sweetScroll = new SweetScroll();
  let search = window.location.search;
  // Выризаем хешь из урла
  let hash = search.match(/hash_id=([^&]+)/);
  if (!hash) return;
  document.addEventListener('DOMContentLoaded', () => {
    window.addEventListener('load', () => {
      // Доскролеваем при закгруски странице
      sweetScroll.to(`#${hash[1]}`, { updateURL: 'replace' });
    });
  });
};
