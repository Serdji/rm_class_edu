const fillFields = require('./fillFields');

module.exports = nodes => {
  nodes.buttonOpen.addEventListener('click', open);
  function open() {
    // Вписываем сохраненные данные пользователя, после его возврата полсе регистрации
    fillFields(nodes);
    nodes.popUpQuestion.classList.add('_activ');
    // Задаем body margin-right на ширину скрола
    document.body.style.marginRight = `${window.innerWidth - document.documentElement.clientWidth}px`;
    document.body.classList.add('_off-scroll'); // Отключаем скрол у body
  }
};
