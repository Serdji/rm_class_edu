const { CONTACT_FORM_QUES,
        CONTACT_FORM_ANSWER
      }                  = require('./constants');
const validationForm     = require('./validationForm');
const { qs, declOfNum }  = require('utils'); // Склонятор
const count              = declOfNum()(['cимвол', 'cимвола', 'cимволов']);

module.exports = (nodes ,input, outputCounter, maxNumber, startingValid ) => {

  if (qs('.js-contact-form-answer')) nodes.sendButton.setAttribute('disabled', 'disabled');

  let timerId;

  // Вызываем функцию с интервалом при фокусе
  function interval () {
    if (this.classList.contains('js-text-question')){}
    timerId = setInterval( () => {
      let lengthText = this.innerText.length;
      let remainderLength  = maxNumber - lengthText;
      // Обрезать текст, если текст скопировали и вставели больше символов чем разрешено
      if ( remainderLength < 0 ) {
        let cutText     = this.innerText.slice(0, maxNumber);
        this.innerText  = cutText;
        remainderLength = maxNumber - cutText.length;
        outputCounter.innerText = `Осталось ${remainderLength} ${count(remainderLength)}`;
      } else {
        maxLength(null, this);
      }
    }, 1000);
  }


  input.addEventListener('keyup', maxLength);
  input.addEventListener('keydown', stopKey);
  input.addEventListener('focus', interval);
  input.addEventListener('blur', () => clearInterval(timerId));

  // При тачи, поставить курсо и дать возможность стереть
  input.addEventListener('touchstart', e => e.currentTarget.setAttribute('contenteditable', 'true'));

  outputCounter.innerText = `Можно ввести ${maxNumber} ${count(maxNumber)}`;

  // Валидация и количество введенных симвалов
  function maxLength( e, self = this ) {
    let lengthText = self.innerText.length;
    let remainderLength  = maxNumber - lengthText;
    switch (nodes.type){
      case CONTACT_FORM_QUES:
        if (self.classList.contains('js-text-question') && startingValid) validationForm(nodes, null, 1);
        break;
      case CONTACT_FORM_ANSWER:
        if ( lengthText === 0 ) nodes.sendButton.setAttribute('disabled', 'disabled');
        if ( lengthText > 0 ) nodes.sendButton.removeAttribute('disabled');
        break;
    }

    if (outputCounter) {
      // Выводим сколько еще можно ввести симвалов
        // Выводить еткст, если 0 символов
      if (lengthText === 0) outputCounter.innerText = `Можно ввести ${maxNumber} ${count(maxNumber)}`;
        // Выводить текст, по ходу ввдода
      if ( lengthText > 0 ) outputCounter.innerText = `Осталось ${remainderLength} ${count(remainderLength)}`;
    }
  }

  // Отключить ввод при привышении лимита
  function stopKey(e) {
    let lengthText = this.innerText.length;
    // Если привышает задоного колличества симвалов останавливает собыите пичатать
    if (lengthText >= maxNumber && e.keyCode !== 8) {
      this.setAttribute('contenteditable', 'false');
    }
  }

};
