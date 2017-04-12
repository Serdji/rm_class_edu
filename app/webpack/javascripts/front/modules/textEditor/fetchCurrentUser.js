const { qs, qsa, each, fetchAutToken } = require('utils');

module.exports = nodes => {
  const answerUi = qsa('.js-answer-ui');
  const bestAnswerButtonsContainer = qsa('.ellipsis__send');
  const hasBestAnswer = qs('#best-answer');

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

        each(bestAnswerButtonsContainer, el => {
          if (isSentry && !hasBestAnswer) {

              let button = document.createElement('a');
              button.classList.add('_hover-reference-blue');
              button.classList.add('js-make-best-answer');
              button.innerHTML = 'Лучший ответ';
              let parent = el.closest('.js-block-answers');

              if (parent !== null) {
                  let id = parent.getAttribute('data-answer-id');
                  button.setAttribute('data-url', '/answers/' + id + '/make_best/');
                  el.appendChild(button);
              }


          }
        });

        each(answerUi, el => {
          // Показываем поле с аватаркой и именем пользователя, добавляем аватарку и имя пользователя полученые с сервера
          el.classList.remove('_disabled-user');
          el.querySelector('.js-answer-ui-avatar').setAttribute('src', avatarUrl);
          // Если у пользователя нет имени и фамилии пишем Ученик с id ананима
          el.querySelector('.js-answer-ui-avatarname').innerText = firstName || lastName ? `${firstName} ${lastName}` : `Ученик ${anonymousId}`;



          if (!isSentry) el.querySelector('.js-answer-ui-sentry').remove();
        });
      })
      .catch(error => {
        console.error(error.message);
      });
};
