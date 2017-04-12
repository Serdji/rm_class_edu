module.exports = () => {
  document.body.addEventListener('click', showHideText);

  function showHideText(e) {
    // Дилегируем событие
    if (e.target.closest('.js-biog-desc')) {
      let text = e.target.dataset.text; // Забераем оригинальный текст из даты
      if (!text) return;
      e.target.closest('.js-biog-desc').innerHTML = text; // Вставляем оригинальны текст
    }
  }
};
