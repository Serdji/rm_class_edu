const { qs, each, fetchAutToken } = require('utils');
const validationForm              = require('./validationForm');
const maxLengthText               = require('./maxLengthText');

module.exports = (nodes) => {
  // Собираем добавленые темы
  let arrVal   = qs('.selectize-input').querySelectorAll('.item');

  // Если есть картинки собераем их ID для отправки на сервер
  let image_ids = [];
  if (nodes.textDescription.querySelectorAll('img')){
    each(nodes.textDescription.querySelectorAll('img'), el=> {
      let id = el.id;
      image_ids.push(+id);
    });
  }
  // Забераем контент из текстового редактора
  let objValue = {
    title: nodes.textQuestion.innerText,
    body: nodes.textDescription.innerHTML,
    tags: nodes.selectTag.getAttribute('value'),
    url: nodes.form.getAttribute('action')
  };

  let { title, body, tags, url } = objValue;

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
        image_ids
      }
    })
  };

  // Отправляем запрос на сервер
  fetchAutToken(params)
    .then( params => fetch(url, params))
    .then(response => {
      let { status } = response;
      let json = response.json();

      if (status >= 200 && status < 300) {
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


      // Перебрасываем пользователя на созданую страницу с вопросом
      window.location = json.url;
    })
    .catch(error => {
      switch (error.message) {
        case '401':
          // Проверка на авторизацию
          qs('.rambler-topline__user-signin').click();
          break;
        case '422':
          // Валидация формы при ошибке
          validationForm(nodes, arrVal, null);
          maxLengthText(nodes, nodes.textQuestion, nodes.outputCounterQuestion, 147, true);
          break;
      }
    });
};
