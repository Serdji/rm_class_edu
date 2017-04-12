const { each } = require('utils');
module.exports = nodes => {
  each(nodes.swPoints, el => el.addEventListener('touchend', switchingPointsMenu));
  function switchingPointsMenu() {
    each(nodes.swPoints, el => el.classList.remove('_activ'));
    this.classList.add('_activ');
  }
};
