const { each, qs } = require('utils');

module.exports = nodes => {
  each(nodes.openShare, el => el.addEventListener('touchend', openShare));

  // Поверка на сео-блок на странице
  if (qs('.seo-block__icon')) {
    // Скрываем иконку как зашли на страницу, для того, что бы в iOS 9 на iphon перерисовывались CSS
    qs('.seo-block__icon').style.display = 'none';
    // Через секунду показываем иконку
    setTimeout(()=>{
      qs('.seo-block__icon').removeAttribute('style');
    }, 1000);
  }

  function openShare() {
    setTimeout(()=>{
      this.closest('.js-common-social').classList.add('_activ');
      this.remove();
    }, 300);
  }
};
