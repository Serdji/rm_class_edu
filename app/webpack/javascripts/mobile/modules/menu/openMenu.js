const offScroll = require('./offScroll');
module.exports = nodes => {
  nodes.buttonMenu.addEventListener('touchend', openMenu);
  function openMenu() {
    setTimeout(() => {
      nodes.menu.classList.remove('_hidden');
      document.body.classList.add('_off-scroll');
      document.body.addEventListener('touchmove', offScroll); // Блок скролла на IOS
    }, 0);
  }
};
