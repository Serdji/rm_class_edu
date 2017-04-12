const selectLengthCounter = require('./selectLengthCounter');
const { declOfNum, fetchAutToken } = require('utils'); // Склонятор
const count = declOfNum()(['тема', 'темы', 'тем']);

// Выбираем нужные плагены из jquery UI
require('jquery-ui/ui/widgets/draggable');
require('jquery-ui/ui/widgets/sortable');

require('selectize');

module.exports = (nodes) => {
  // Максимальное колличество тегов
  let maxTag     = 10;
  let $selectTag = $('.js-select-tag');
  // Конфиг для selectize
  let options = {
    plugins: ['remove_button', 'drag_drop'],
    valueField: 'id',
    labelField: 'name',
    searchField: 'name',
    create: false,
    maxItems: maxTag,
    // Событие при добавление тега
    onChange(arrVal) {
      selectLengthCounter(nodes, arrVal, maxTag);
      $selectTag.attr('value', arrVal);
      $selectTag
        .next()
        .children('.has-items')
        .removeClass('_editor-error _editor-ok');
    },
    render: {
      option(tags) {
        let { id, name } = tags;
        return `<div id="${id}" class="option" data-selectable="" data-value="">${name}</div>`;
      }
    },
    load(query, callback) {
      if (!query.length) return callback();
      $.ajax({
        url: '/tags/search/' + encodeURIComponent(query),
        type: 'GET',
        error() {
          callback();
        },
        success(data) {
          callback(data);
        }
      });
    }
  };
  // Текст по умолчанию при входе
  $('.js-max-length-counter-select').text(`Можно добавить ${maxTag} ${count(maxTag)}`);

  // Создаем selectize
  let $selectState = $selectTag.selectize(options);
  let selectState = $selectState[0].selectize;

  selectState.clear();
  selectState.clearOptions();

  selectState.load((callback) => {
    fetchAutToken({})
      .then( (params) => fetch('/tags/options', params))
      .then( (response) => response.json() )
      .then( (options) => { callback(options) } )
  })

  // При закрытии формы, отчищаем теги
  $('.js-close-pop-up-ques').on('click', () => selectState.clear());
};
