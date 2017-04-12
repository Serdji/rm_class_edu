const { qs, fetchAutToken, each } = require('utils');

module.exports = nodes => {
  each(nodes.buttonOpen, el => {
    el.addEventListener('click', open);
  });
  //  Функция открытия самого попапа
  function openPopUp(self) {
    // Ищим родителя по css силектору
    let complainable = self.closest('[data-complainable="true"]');
    // Собираем данные с формы
    let complainableId = complainable.dataset.complainableId;
    let complainableType = complainable.dataset.complainableType;
    // Добавляем данные
    nodes.complaintForm.elements['complaint[complainable_id]'].value = complainableId;
    nodes.complaintForm.elements['complaint[complainable_type]'].value = complainableType;

    nodes.popUpComplaint.classList.add('_activ');
    // Задаем body margin-right на ширину скрола
    document.body.style.marginRight = `${window.innerWidth - document.documentElement.clientWidth}px`;
    document.body.classList.add('_off-scroll'); // Отключаем скрол у body
  }

  // Отрыть попап только при уловии
  function open(e) {
    e.preventDefault();

    let params = { method: 'POST'};
    // Отправляем запрос на сервер с целью узнать, пользователь зарегестрирован или нет
    fetchAutToken(params)
      .then( params => fetch('/profile', params))
      .then( response => {
        // Если ОК, открываем попап
        let { status, statusText } = response;
        if (status >= 200 && status < 300) {
          openPopUp(this);
        } else {
          throw new Error(statusText);
        }
      })
      .catch(error => {
        // Если нет, то открываем форму аунтификации и регистрации
        if (error.message === 'Unauthorized') {
          qs('.rambler-topline__user-signin').click();
          // Колбек, после аунтификации открываем форму пожалолваться
          ramblerIdHelper.registerOnPossibleLoginCallback(() => { openPopUp(this); });
        }
      });
  }
};
