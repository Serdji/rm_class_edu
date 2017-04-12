module.exports = (() => {
  // Дилегиуем событие на созданый таб
  document.body.addEventListener('touchend', openTags);
  function openTags(e) {
    let target = e.target;
    setTimeout(()=>{
      // Если всплываем не черз тег, останавливаем скрипт
      if (!target.closest('.js-open-tags')) return;
      // Открываем все теги и удаляем тег кнопку
      target.closest('.js-hash-tags').classList.remove('_hide');
      target.closest('.js-open-tags').remove();
    }, 300);
  }
})();
