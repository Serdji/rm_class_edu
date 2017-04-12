const { fetchAutToken, qs } = require('utils');
const socialButton          = require('../socialButton')

module.exports = nodes => {
  // Забераем контент из текстового редактора
  let editorContent = tinymce.activeEditor.getContent();
  let url           = nodes.form.getAttribute('action');
  // Проверка на содержимое редактора
  if (editorContent) {
    let splittedPath = location.pathname.split('/');
    let id           = splittedPath[splittedPath.length - 1];

    let imageIds = tinymce.activeEditor.uploadedImageIds;

    // Передаем параметры
    let params = {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        body: editorContent,
        image_ids: imageIds
      })
    };

    fetchAutToken(params)
      .then( params => fetch(url, params))
      .then( response => {
        let { status, statusText } = response;

        if (status >= 200 && status < 300) return response.json();
        else throw new Error(statusText);
      })
      .then(json => {
        if (!json) return;

        if (window.ga && window.yaCounter38595795) {
          ga('send', 'event', 'страница_вопроса', 'ответ_на_вопрос', 'нажатие_на_кнопку_отправить');
          yaCounter38595795.reachGoal('otvet_na_vopros');
        }

        // Вставляем содержимое сообщения в DOM
        let compiled = nodes.answerTemplate({ answer: json });
        nodes.allAnswers.insertAdjacentHTML('beforeEnd', compiled);
        socialButton();
        // Прибавляме количество ответов
        nodes.answers.innerHTML = ++nodes.answers.innerHTML;

        if (nodes.answers.innerHTML > 0) nodes.answers.closest('.question-common__up-title').classList.remove('_hidden');

        // console.log(tinymce.activeEditor.getContent({format: 'text'}).length);
        // Отчищаем поле ввода
        tinymce.activeEditor.setContent('');
        delete tinymce.activeEditor.uploadedImageIds;
      })
      .catch(error => {
        if (error.message === 'Unauthorized') qs('.rambler-topline__user-signin').click();
      });
  }
};
