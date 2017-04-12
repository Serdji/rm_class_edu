const offScroll = require('./offScroll');
module.exports = nodes => {
  nodes.menuCurtain.addEventListener('touchend', closeMenu);
  function closeMenu() {
    nodes.menu.classList.add('_hidden');
    document.body.classList.remove('_off-scroll');
    document.body.removeEventListener('touchmove', offScroll); // Снимаем блок скролла на IOS
  }
};
