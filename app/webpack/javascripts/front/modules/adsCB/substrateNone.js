const { qs }          = require('utils');
let height240x400     = false;
let height240x400_2nd = false;

module.exports = () => {
  // Колбек отрабатывает после загрузке всей рекламмы
  Begun.Autocontext.Callbacks.register({
    block: {
      draw() {
        // каждые 500ms проверяем банеры
        let intId = setInterval(() => {
          let ban240x400     = qs('#ban_240x400 div[id^="begun_block"]');
          let ban240x400_2nd = qs('#ban240x400_2nd div[id^="begun_block"]');
          // Проверяем наличие банера
          if (!height240x400 && ban240x400) {
            // Берем его высоту
            height240x400 = ban240x400.clientHeight;
            // Если высота больше чем 400 убераем боложку у банера 240x400
            if (height240x400 !== 0 && height240x400 > 400) {
              document.getElementById('ban_240x400').closest('.baner').classList.remove('_base-layer_240x400')
            }
          }
          // Проверяем наличие банера
          if (!height240x400_2nd && ban240x400_2nd) {
            // Берем его высоту
            height240x400_2nd = ban240x400_2nd.clientHeight;
            // Если высота больше чем 400 убераем боложку у банера 240x400_2nd
            if (height240x400_2nd !== 0 && height240x400_2nd > 400) {
              document.getElementById('ban240x400_2nd').closest('.baner').classList.remove('_base-layer_240x400_2nd')
            }
          }
        }, 500);
        // через 10 секунд перестаем проверять
        setTimeout(() => {
          clearInterval(intId);
        }, 10000);
      }
    },
  });
}
