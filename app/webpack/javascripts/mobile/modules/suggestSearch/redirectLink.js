const { qs } = require('utils');

module.exports = () => {
  // qs('.js-search-linck')
  document.body.addEventListener('click', redirect, false);

  function redirect(e) {
    let searchLinck = e.target.closest('.js-search-linck');

    if (searchLinck) {
      window.location = `${searchLinck.dataset.href}${qs('.js-search-input').value}`;
    }
  }
};
