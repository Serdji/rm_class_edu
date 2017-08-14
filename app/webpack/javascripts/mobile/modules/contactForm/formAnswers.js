const { each, fetchAutToken, qs } = require('utils');

module.exports = nodes => {

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
    body: nodes.textDescription.innerHTML,
    url: nodes.form.getAttribute('action')
  };
  let backUrl = nodes.sendButton.dataset.backUrl;
  let { body, url } = objValue;
    // Передаем параметры
    let params = {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        body,
        image_ids
      })
    };


    fetchAutToken(params)
      .then( params => fetch(url, params))
      .then( response => {
        let { status } = response;
        if (status >= 200 && status < 300) return response.json();
        else throw new Error(status);
      })
      .then(json => {
        if (!json) return;

        // Возвращаемся на страницу с вопросом, плюс хеш для прокрутки экрана до своего ответа
        window.location = `${backUrl}#answers-${json.id}`;
      })
      .catch(error => {
        switch (error.message) {
          case '401': qs('.rambler-topline__user-signin').click(); break;
        }
      });
};

