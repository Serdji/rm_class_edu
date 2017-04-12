const { fetchAutToken } = require('utils');

module.exports = nodes => {
  nodes.buttonClose.addEventListener('click', close);
  function close() {
    fetchAutToken({method: 'POST'}).then( (params) => fetch('/users/question/clear', params));
    nodes.popUpQuestion.classList.remove('_activ');
    document.body.removeAttribute('style'); // удаляем атрибут style у body
    document.body.classList.remove('_off-scroll'); // Включаем скрол у body
  }
};
