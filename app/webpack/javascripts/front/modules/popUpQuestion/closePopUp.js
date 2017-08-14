module.exports = nodes => {
  nodes.buttonClose.addEventListener('click', close);

  function close() {
    delete localStorage['formQuestion']; // Удаляем из стора сохраненые данные из формы
    nodes.popUpQuestion.classList.remove('_activ');
    setTimeout(()=>  hideErrors(), 100);
    document.body.removeAttribute('style'); // удаляем атрибут style у body
    document.body.classList.remove('_off-scroll'); // Включаем скрол у body
  }

  function hideErrors() {
    nodes.titleError.classList.add('_hidden');
    nodes.maxLengthCounter.classList.remove('_hidden');

    nodes.tagIdsError.classList.add('_hidden');
    nodes.maxLengthCounterSelect.classList.remove('_hidden');
  }
};
