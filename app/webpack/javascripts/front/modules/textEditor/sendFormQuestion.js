const { fetchAutToken, qs } = require('utils');
const errorStyle        = require('./errorStyle');
const validationForm    = require('./validationForm');

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

  // Поле которое не заполнено, выделяется красной рамкой
  validationForm(nodes, ed, objValue);

  // Проверка на содержимое формы, все поля должны быть заполнены
  if (title && tags) {
    let params = {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        question: {
          title,
          body,
          tag_ids: tags.split(','),
          image_ids: imageIds
        }
      })
    };

    fetchAutToken(params)
      .then( params => fetch(url, params))
      .then(response => {
        let { status, statusText } = response;
        if (status >= 200 && status < 300) return response.json();
        else throw new Error(statusText);
      })
      .then(json => {
        if (!json) return;

        if (window.ga && window.yaCounter38595795) {
          ga('set', 'page', '/forma_zadat_vopros');
          yaCounter38595795.hit('/forma_zadat_vopros');
        }
        // Перебрасываем пользователя на созданую страницу с вопросом
        delete tinymce.activeEditor.uploadedImageIds;
        window.location = json.url;
      })
      .catch(error => {
        if (error.message === 'Internal Server Error' ||
            error.message === 'Unprocessable Entity') {
          errorStyle(nodes, ed);
        }
        if (error.message === 'Unauthorized') {
          errorStyle(nodes, ed);
          qs('.rambler-topline__user-signin').click();
          ramblerIdHelper.registerOnPossibleLoginCallback(()=> validationForm(nodes, ed, objValue));
          // Отправляем форму на сервер, если усер не зарегестрирован, для сохранени если он уйдет на регистрацию
          fetchAutToken(params).then( params => fetch('/users/question', params));
        }
      });
  }
};
