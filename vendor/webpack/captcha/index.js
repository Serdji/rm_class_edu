require('./captcha');
const { qs } = require('utils');

module.exports = class Captcha {
  constructor(elem, url = '/captcha/create'){
    this.elem   = qs(elem);
    this.url    = url;
  }

  // HTML шаблон капчи
  static templateCaptcha({ id, image }) {
    return `<div class="captcha" data-captcha-id="${id}">
              <span class="captcha__title">Символы с картинки</span>
              <img class="captcha__img" src="data:image/png;base64,${image}">
              <div class="captcha__update">
                <span>Обновить картинку</span>
                <div class="captcha__arrow"></div>
              </div>
              <div class="input-select">
                <input class="captcha__input">
              </div>
            </div>`
  }

  // Событие на кнопку обновить
  update(){
    this.elem.addEventListener('click', e => { if (e.target.closest('.captcha__update > span')) this.run() })
  }

  // Получить ID капчи
  getId(){
    let captcha = this.elem.querySelector('.captcha');
    return captcha ? captcha.dataset.captchaId : '';
  }

  // Получить текст из инпута
  getInput(){
    let input = this.elem.querySelector('.captcha__input');
    return input ? input.value : '';
  }

  // Удалить капчу
  remove(){
    if(this.elem.querySelector('.captcha')) this.elem.querySelector('.captcha').remove();
  }

  // Оправляем запрос, запалняем шаблон данными и выводим в DOM
  run(){
    fetch(this.url, {method: 'POST'})
      .then( response => {
        let { status, statusText } = response;
        if (status >= 200 && status < 300) return response.json();
        else throw new Error(statusText);
      })
      .then(json => {
        this.elem.innerHTML = Captcha.templateCaptcha(json);
        // Отключам отправку по нажатию на enter
        this.elem.addEventListener('keydown', e => {
          if(e.keyCode === 13) {
            e.preventDefault();
            return false;
          }
        })
      })
      .catch(({message}) => {
        console.log(message);
      });
  }
}
