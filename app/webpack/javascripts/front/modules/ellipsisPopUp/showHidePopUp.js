const { each } = require('utils');
module.exports = nodes => {
  each(nodes.ellipsis, el => el.addEventListener('click', showHide));
  document.body.addEventListener('click', hidePopUp, true);
  function showHide() {
    let isClass = this.classList.contains('_activ');
    each(nodes.ellipsis, el => el.classList.remove('_activ'));
    this.classList[isClass ? 'remove' : 'add']('_activ');
  }
  function hidePopUp(e) {
    let isParent = e.target.closest('.js-ellipsis-pop-up');
    if (!isParent) each(nodes.ellipsis, el => el.classList.remove('_activ'));
  }
};
