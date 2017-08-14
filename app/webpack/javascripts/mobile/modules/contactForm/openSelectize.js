const { qs } = require('utils');
const SweetScroll = require('sweet-scroll');

module.exports = (nodes) => {
  nodes.textTheme.addEventListener('touchend', openSelect);
  document.body.addEventListener('click', closeSelect);

  function openSelect() {
    const sweetScroll = new SweetScroll({offset: -51});
    // При нажатии на темы, скрываем div и показываем input с темами
    this.classList.add('_hidden');
    nodes.inputTheme.classList.remove('_hidden');

    setTimeout(()=>{
      sweetScroll.to('.js-theme-input');
    }, 300)
  }
  function closeSelect(e) {
    if (!e.target.closest('.js-theme-input')) {
      // Проверяем, если нет не одной темы, скрываем input показываем div
      if(qs('.selectize-input').querySelectorAll('.item').length === 0){
        nodes.textTheme.classList.remove('_hidden');
        nodes.inputTheme.classList.add('_hidden');
      }
    }
  }
};
