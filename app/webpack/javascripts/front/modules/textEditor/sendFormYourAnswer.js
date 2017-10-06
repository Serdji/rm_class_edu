const Captcha               = require('captcha');
const { fetchAutToken, qs } = require('utils');
const socialButton          = require('../socialButton');

module.exports = nodes => {
  // Забераем контент из текстового редактора
  let editorContent = tinymce.activeEditor.getContent();
  let url           = nodes.form.getAttribute('action');
  let captcha       = new Captcha('.js-captcha-answer');
  // Проверка на содержимое редактора
  if (editorContent) {
    let splittedPath = location.pathname.split('/');
    let id           = splittedPath[splittedPath.length - 1];
    let imageIds     = tinymce.activeEditor.uploadedImageIds;

    // Передаем параметры
    let params = {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        body: editorContent,
        image_ids: imageIds,
        captcha: {
          id: captcha.getId(),
          input: captcha.getInput()
        }
      })
    };
    nodes.formButton.setAttribute('disabled', 'disabled');

    // Колбеки включают кнопки при входе пользователя зерез соц сетку и на прямую
    ramblerIdHelper.registerOnPossibleOauthLoginCallback(()=> nodes.formButton.removeAttribute('disabled'));
    ramblerIdHelper.registerOnPossibleLoginCallback(()=> nodes.formButton.removeAttribute('disabled'));

    fetchAutToken(params)
      .then( params => fetch(url, params))
      .then( response => {

        let { status, statusText } = response;
        let json = response.json();
        if (status >= 200 && status < 300) {
          captcha.remove();
          return json;
        } else {
          throw new Error(status);
        }
      })
      .then(json => {
        if (!json) return;

        // captcha.remove();

        if (window.ga && window.yaCounter43407474) {
          ga('send', 'event', 'страница_вопроса', 'ответ_на_вопрос', 'нажатие_на_кнопку_отправить');
          yaCounter43407474.reachGoal('otvet_na_vopros');
        }

        // Вставляем содержимое сообщения в DOM
        let compiled = nodes.answerTemplate({ answer: json });
        nodes.allAnswers.insertAdjacentHTML('beforeEnd', compiled);

        // После добовления сообщения включить кнопку
        setTimeout(() => {
          nodes.formButton.removeAttribute('disabled');
        }, 1000);

        socialButton();
        // Прибавляме количество ответов
        nodes.answers.innerHTML = ++nodes.answers.innerHTML;

        if (nodes.answers.innerHTML > 0) nodes.answers.closest('.question-common__up-title').classList.remove('_hidden');

        // console.log(tinymce.activeEditor.getContent({format: 'text'}).length);
        // Отчищаем поле ввода
        tinymce.activeEditor.setContent('');
        delete tinymce.activeEditor.uploadedImageIds;
      })
      .catch(({message}) => {
        switch (message){
          case '401':
            nodes.formButton.removeAttribute('disabled');
            qs('.rambler-topline__user-signin').click();
            break;
          case '429':
            nodes.formButton.removeAttribute('disabled');
            captcha.run();
            break;
        }
      });
  }
};
