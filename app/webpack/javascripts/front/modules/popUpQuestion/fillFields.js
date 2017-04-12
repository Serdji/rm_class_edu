const { fetchAutToken, qs } = require('utils');

module.exports = nodes => {
  let selectTag = qs('.js-select-tag');

  // Гет запрос, на получение сохраненных данных ссервера которорые вводил пользователь перед переходон на регистрацию
  fetchAutToken({})
    .then( (params) => fetch('/users/question', params))
    .then( response => {
      return response.json();
    }).then(json => {
      if (!json) return;
      let { body, title } = json;
      tinymce.get('ditor-quantity').setContent(body);
      selectTag.selectize.setValue(json.tag_ids);
      nodes.input.value = title;
    });
};
