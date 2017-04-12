module.exports = nodes => {
  nodes.buttonClose.addEventListener('click', close);
  function close() {
    nodes.popUpComplaint.classList.remove('_activ');

    // Удаляем инлайновые стили
    nodes.complaintForm.style.display = '';
    nodes.complaintSuccess.style.display = '';

    document.body.removeAttribute('style'); // удаляем атрибут style у body
    document.body.classList.remove('_off-scroll'); // Включаем скрол у body

    nodes.complaintForm.reset();
  }
};
