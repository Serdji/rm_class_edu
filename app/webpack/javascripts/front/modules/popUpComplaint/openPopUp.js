const { qs, fetchAutToken, each } = require('utils');
const Captcha = require('captcha');

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
        let { status } = response;
        if (status >= 200 && status < 300) {
          return response.json();
        } else {
          throw new Error(status);
        }
      })
      .then( json => {
        let { is_fake: isFake } = json;

        // Проверка на отличника, отправлям жалубу без формы
        if ( isFake ){
          // Ищим родителя по css силектору
          let complainable     = this.closest('[data-complainable="true"]');
          // Собираем данные с формы
          let complainableId   = complainable.dataset.complainableId;
          let complainableType = complainable.dataset.complainableType;
          let captcha          = new Captcha('.js-captcha-complaint');
          const url            = nodes.complaintForm.action;

          let par = {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
              complaint: {
                complainable_id: complainableId,
                complainable_type: complainableType,
                cause_ids: [],
                body: '',
                email: ''
              },
              captcha: {
                id: captcha.getId(),
                input: captcha.getInput()
              }
            })
          };

          fetchAutToken(par)
            .then( par => fetch(url, par))
            .then( response => {
              let json = response.json();
              let { status } = response;
              if (status >= 200 && status < 300) {
                nodes.popUpComplaint.classList.add('_activ');
                nodes.complaintForm.style.display = 'none';
                nodes.complaintForm.reset();
                nodes.complaintSuccess.style.display = 'table-cell';
              } else {
                return json.then(responseError => {
                  let error = Error(status);
                  error.errors = responseError.errors;
                  throw error;
                });
              }
            })
            .catch(error => {
              console.log(error);
          });

        } else {
          openPopUp(this);
        }
      })
      .catch(error => {
        // Если нет, то открываем форму аунтификации и регистрации
        if (error.message === '401') {
          qs('.rambler-topline__user-signin').click();
          // Колбек, после аунтификации открываем форму пожалолваться
          ramblerIdHelper.registerOnPossibleLoginCallback(() => {
            // Проверка на то, открыт ли поп-оп задать вопрос
            if (!nodes.popUpQuestion.classList.contains('_activ')) openPopUp(this);
          });
        }
      });
  }
};
