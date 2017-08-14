const { qs, qsa, each, fetchAutToken } = require('utils');

function fetchCurrentUser() {

  let nodes = {
    author: qs('.js-author'),
    user: qsa('.js-user')
  };

  let params = { method: 'POST'};
// Отправляем post запрос на нашь сервер
  fetchAutToken(params)
    .then( params => fetch('/profile', params))
    .then( response => {
      let { status, statusText } = response;
      if (status >= 200 && status < 300) {
        return response.json();
      } else {
        throw new Error(statusText);
      }
    })
    .then(json => {
      // Деструктуризируем json полученный от сервера
      let { avatar_url: avatarUrl,
        first_name: firstName,
        last_name: lastName,
        anonymous_id: anonymousId,
        is_sentry: isSentry
      } = json;

      each(nodes.user, el => {

        // Показываем поле с аватаркой и именем пользователя, добавляем аватарку и имя пользователя полученые с сервера
        el.classList.remove('_disabled-user');
        el.querySelector('.js-user-avatar').style.cssText = `background-image: url(${avatarUrl})`;
        // Если у пользователя нет имени и фамилии пишем Ученик с id ананима
        el.querySelector('.js-user-name').innerText = firstName || lastName ? `${firstName} ${lastName}` : `Ученик ${anonymousId}`;

        // Убераем кнопку аунтификации и выводит пользователя
        nodes.author.classList.add('_hidden');
        el.classList.remove('_hidden');
      });
    })
    .catch(() => {
      nodes.author.classList.remove('_hidden');
    });

  // Кпопка выжода для пользователя
  qs('.js-user-output').addEventListener('click', ()=>{
    qs('.rambler-topline-user-dropdown__logout').click();
  })
}

module.exports = fetchCurrentUser;
fetchCurrentUser();
