const { each, qs } = require('utils');
const OG_DEFAULT_PNG = 'https://class.rambler.ru/8f56f789/front/opengraph.png';

module.exports = (nodes) => {
  // Общий конфиг для шарилок
  let options = {
    'style': {
      'buttonHeight': 30,
      'iconSize': 14,
      'borderRadius': 50
    },
    'utm': 'utm_source=social',
    'counters': false,
    'buttons': [
      'vkontakte',
      'facebook',
      'livejournal',
      'odnoklassniki',
      'twitter'
    ],
    'twitter': {
      'description': ' '
    }
  };
  let maxLengthText = 140;
  let init = () => {
    // При уловии что шарелки цветные
    if (nodes.questionSocial) {
      // Выводим шарелки
      RamblerShare.init('.js-question-social', options);
      // RamblerShare.init('.js-question-social',
      //   Object.assign( options, {
      //     title: qs('.js-question-share').querySelector('.js-question-share-title').innerText,      // Времменно до появления опенграфов
      //     description: qs('.js-question-share').querySelector('.js-question-share-text').innerText.slice(0, maxLengthText) + '...'  // Времменно до появления опенграфов
      //   })
      // );
    }

    // Прозрачные шарелки
    if (nodes.commonSocial) {
      // Кланируем основной объект
      let commonSocialOptions = Object.assign({}, options);
      // Добавляем общие стили в конфиг
      Object.assign(commonSocialOptions.style, {
        'borderWidth': 1,
        'buttonBackground': 'rgba(40,86,248,0)',
        'iconColor': '#315efb',
        'borderColor': '#315efb',
        'buttonBackgroundHover': '#315efb',
        'buttonHeight': 24,
        'iconSize': 12,
        'borderRadius': 50
      });

      // Бежим циклом по нужным нам элементам
      each(nodes.commonSocial, el => {
        // Подключаемся к блокам в которых выведены шарелки
        let questionParentIsClass  = el.closest('.js-question-share');
        let answerParentIsClass    = el.closest('.js-answer-share');
        let questionsParentIsClass = el.closest('.js-questions-share');
        let tagParentIsClass       = el.closest('.js-tag-share');
        let searchParentIsClass    = el.closest('.js-search-share');

        // В зависимости от того блока в котором шарелки, расширяем конфиг со своими насторйками
        // Вопрос
        if (questionParentIsClass) {
          RamblerShare.init(`[data-social-link='${el.dataset.socialLink}']`, commonSocialOptions);
          // RamblerShare.init(`[data-social-link='${el.dataset.socialLink}']`,
          //   Object.assign( commonSocialOptions, {
          //     title: questionParentIsClass.querySelector('.js-question-share-title').innerText,      // Времменно до появления опенграфов
          //     description: questionParentIsClass.querySelector('.js-question-share-text').innerText.slice(0, maxLengthText) + '...',  // Времменно до появления опенграфов
          //   })
          // );
        }
        // Лучший ответ и ответы
        if (answerParentIsClass) {
          RamblerShare.init(`[data-social-link='${el.dataset.socialLink}']`,
            Object.assign(commonSocialOptions, {
              description: answerParentIsClass.querySelector('.js-answer-share-text').innerText.slice(0, maxLengthText) + '...',
              url: `${window.location.origin}${window.location.pathname}?hash_id=${answerParentIsClass.id}`,
            })
          );
        }

        // Вопросы
        if (questionsParentIsClass) {
          RamblerShare.init(`[data-social-link='${el.dataset.socialLink}']`,
            Object.assign(commonSocialOptions, {
              title: questionsParentIsClass.querySelector('.js-questions-share-title').dataset.title,
              description: questionsParentIsClass.querySelector('.js-questions-share-text').innerText.slice(0, maxLengthText) + '...',
              url: `${window.location.origin}${questionsParentIsClass.querySelector('.js-questions-share-title').getAttribute('href')}`,
              image: OG_DEFAULT_PNG
            })
          );
        }

        // Теги - темы
        if (tagParentIsClass) {
          let attrHref = tagParentIsClass.querySelector('.js-tag-share-title').getAttribute('href');
          let dataHref = tagParentIsClass.querySelector('.js-tag-share-title').dataset.href;
          RamblerShare.init(`[data-social-link='${el.dataset.socialLink}']`,
            Object.assign(commonSocialOptions, {
              title: tagParentIsClass.querySelector('.js-tag-share-title').innerText,
              description: tagParentIsClass.querySelector('.js-tag-share-title').innerText.slice(0, maxLengthText) + '...',
              url: `${window.location.origin}${attrHref || dataHref}`,
              image: tagParentIsClass.querySelector('.js-tag-share-img').dataset.image
            })
          );
        }

        // Результаты поиска
        if (searchParentIsClass) {
          RamblerShare.init(`[data-social-link='${el.dataset.socialLink}']`, commonSocialOptions);
        }
      });
    }
  };
  return init;
};
