const { fetchAutToken, qs } = require('utils');
const validationForm        = require('./validationForm');
const Captcha               = require('captcha');

module.exports = (nodes, ed) => {
// Забераем контент из текстового редактора
  let objValue = {
    title: nodes.inputQuestion.value,
    body: tinymce.activeEditor.getContent(),
    tags: nodes.selectQuestion.getAttribute('value'),
    url: nodes.questionForm.getAttribute('action')
  };

  let { title, body, tags, url} = objValue;
  let imageIds = tinymce.activeEditor.uploadedImageIds;
  let captcha  = new Captcha('.js-captcha-question');

  // Проверка на содержимое формы, все поля должны быть заполнены
  let params = {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      question: {
        title,
        body,
        tag_ids: (tags || '').split(','),
        image_ids: imageIds
      },
      captcha: {
        id: captcha.getId(),
        input: captcha.getInput()
      }
    })
  };

  nodes.sendQuestion.setAttribute('disabled', 'disabled');

  fetchAutToken(params)
    .then( params => fetch(url, params))
    .then(response => {
      let { status  } = response;
      let json = response.json();

      if (status >= 200 && status < 300) {
        captcha.remove();
        return json;
      } else {
        return json.then(responseErrors => {
          let error = new Error(status);
          error.errors = responseErrors;
          throw error;
        });
      }
    })
    .then(json => {
      if (!json) return;

      if (window.ga && window.yaCounter43407474) {
        ga('set', 'page', '/forma_zadat_vopros');
        yaCounter43407474.hit('/forma_zadat_vopros');
      }
      // Перебрасываем пользователя на созданую страницу с вопросом
      delete tinymce.activeEditor.uploadedImageIds;
      delete localStorage['formQuestion']; // Удаляем из стора сохраненые данные из формы
      window.location = json.url;
    })
    .catch(({message}) => {

      switch (message) {
        case '500':
        case '422':
          validationForm(nodes);
          nodes.sendQuestion.removeAttribute('disabled');
          break;
        case '429':
          nodes.sendQuestion.removeAttribute('disabled');
          captcha.run();
          break;
        case '401':
          qs('.rambler-topline__user-signin').click();
          nodes.sendQuestion.removeAttribute('disabled');
          validationForm(nodes);
          ramblerIdHelper.registerOnPossibleLoginCallback(() => validationForm(nodes));

          // Сохраняем форму в локальный стор, если усер не зарегестрирован, для сохранени если он уйдет на регистрацию
          let objQuestion = JSON.stringify(objValue);
          localStorage.setItem('formQuestion', objQuestion);
          break;
      }
    });
};
