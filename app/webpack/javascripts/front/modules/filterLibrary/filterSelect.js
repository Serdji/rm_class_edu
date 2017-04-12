const { each } = require('utils');
module.exports = nodes => {
  each(nodes.libSelect, el => el.addEventListener('click', openSelect));
  document.body.addEventListener('click', closSelect, true);
  function openSelect() {
    let isClass = this.classList.contains('_open-select'); // Проверка на наличе класса
    each(nodes.libSelect, el => el.classList.remove('_open-select')); // Удаляем класс у всех нод
    this.classList[isClass ? 'remove' : 'add']('_open-select'); // Если такой класс уже стоит удаляем его иначе ставим
    this.firstElementChild.blur(); // Убираем фокус с input
  }
  function closSelect(e) {
    // Дилигируем событие, на клик в не блока, закрываем все списки
    if (!e.target.closest('.js-lib-select')) each(nodes.libSelect, el => el.classList.remove('_open-select'));
  }
};
