const { qs } = require('utils');

module.exports = nodes => {
  let selectTag = qs('.js-select-tag');

  // Проверяем стор на наличие данных, если они есть, выводим их в форму
  if(localStorage.formQuestion) {
    setTimeout(()=> {
      let formQuestion = JSON.parse(localStorage.getItem('formQuestion'));
      let { body, title, tags } = formQuestion;
      tinymce.get('ditor-quantity').setContent(body);
      selectTag.selectize.setValue((tags || '').split(','));
      nodes.input.value = title;
    }, 0);
  }

};
