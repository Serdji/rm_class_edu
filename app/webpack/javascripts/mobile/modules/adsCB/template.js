const {qs, qsa, each} = require('utils');

module.exports = () => {
  // Название меток для реклмы
  let htmlQues = '<div class="js-placement-ques"></div>';
  let htmlTag  = '<div class="js-placement-tag"></div>';

  //Реклама на странице ответа
  if (qs('.js-page-question-ads')) {

    //Реклама в вопросах
    each(qsa('.js-questions-ads'), (el, i) => {
      let index = i + 1;
      if (qsa('.js-questions-ads').length === index) el.insertAdjacentHTML('afterEnd', htmlQues);
    });

    //Реклама в ответах
    if (qs('.js-answer-ads')) {
      each(qsa('.js-answer-ads'), (el, i) => {
        let index = i + 1;
        if (index % 3 === 0 || qsa('.js-answer-ads').length === index ) el.insertAdjacentHTML('afterEnd', htmlQues);
      });
    }

    // Реклама после лучшего ответа
    if(qs('.js-best-answer-ads') && qsa('.js-answer-ads').length !== 1) qs('.js-best-answer-ads').insertAdjacentHTML('afterEnd', htmlQues);

    // Реклама под лушими вопросами
    if (qs('.js-interesting-question-ads')) qs('.js-interesting-question-ads').insertAdjacentHTML('afterEnd', htmlQues);

    // Рекламма елси нет ответов
    if (!qs('.js-answer-ads')) qs('.js-none-answer-ads').insertAdjacentHTML('afterEnd', htmlQues);

    // Реклама на главной странице и странице нулевой выдочи
  } else if ((qs('.js-questions-ads') && qs('.js-tag-ads')) || qs('.js-question-search-ads')) {

    // Реклама в вопросах
    each(qsa('.js-questions-ads'), (el, i) => {
      let index = i + 1;

      // Реклама над пагинацией главная страница
      if (qs('.js-pag-home-ads')) {
        if (index !== 1 && index % 3 !== 0 && qsa('.js-questions-ads').length === index) {
          qs('.js-pag-home-ads').insertAdjacentHTML('afterEnd', htmlQues);
        }
      }

      // Реклама над пагинацией главная темы
      if (qs('.js-pag-tag-ads')) {
        if (index !== 1 && index % 3 === 0 && qsa('.js-questions-ads').length === index) {
          qs('.js-pag-tag-ads').insertAdjacentHTML('afterEnd', htmlQues);
        }
      }

      //Метка для определенной последовательности выдачи
      if (qs('.js-two-ads')) {
        if (index % 3 === 1) el.insertAdjacentHTML('afterEnd', htmlQues);
      } else {
        if (index % 3 === 0) el.insertAdjacentHTML('afterEnd', htmlQues);
      }
    });

    // Реклама под похожами темами
    if (qs('.js-similar-tag-ads')) qs('.js-similar-tag-ads').insertAdjacentHTML('afterEnd', htmlQues);

    // Реклама на странице тем
  } else if (qs('.js-tag-ads')) {

    each(qsa('.js-tag-ads'), (el, i) => {
      if (qsa('.js-tag-ads').length === index) el.insertAdjacentHTML('afterEnd', htmlQues);
      let index = i + 1;
      if (qs('.js-two-ads')) {
        if (index % 3 === 1) el.insertAdjacentHTML('afterEnd', htmlTag);
      } else {
        if (index % 3 === 0) el.insertAdjacentHTML('afterEnd', htmlTag);
      }
    });
  }
};
