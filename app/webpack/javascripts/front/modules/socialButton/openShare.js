const { each } = require('utils');

module.exports = nodes => {
  each(nodes.openShare, el => el.addEventListener('click', openShare));

  function openShare() {
    this.closest('.js-common-social').classList.add('_activ');
    this.remove();
  }
};
