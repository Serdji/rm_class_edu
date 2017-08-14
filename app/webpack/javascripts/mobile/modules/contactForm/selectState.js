const { declOfNum, fetchAutToken } = require('utils'); // Склонятор
const count                        = declOfNum()(['тема', 'темы', 'тем']);
const maxLengthTag                 = require('./maxLengthTag');
const SweetScroll                  = require('sweet-scroll');


require('selectize');

module.exports = (nodes) => {
  // Максимальное колличество тегов
  let maxTag             = 10;
  let $selectTag         = $('.js-select-tag');
  let $outputCounterTag  = $('.js-output-counter-tag');

  // Текст по умолчанию при входе
  $outputCounterTag.text(`Можно добавить ${maxTag} ${count(maxTag)}`);

  // Конфиг для selectize
  let options = {
    plugins: ['remove_button'],
    valueField: 'id',
    labelField: 'name',
    searchField: 'name',
    create: false,
    maxItems: maxTag,
    // Событие при добавление тега
    onChange(arrVal) {
      const sweetScroll = new SweetScroll({offset: -51});
      maxLengthTag(nodes ,arrVal, nodes.outputCounterTag, 10);
      $selectTag.attr('value', arrVal);
      // При выборе темы закрывть выподающей список
      $('.selectize-dropdown').css('display', 'none');
      sweetScroll.to('.js-theme-input');
      $('.selectize-input').on('touchstart', ()=> $('.selectize-dropdown').css('display', 'block'));
      $('.selectize-input').on('keyup', ()=> $('.selectize-dropdown').css('display', 'block'));

    },
    render: {
      option(tags) {
        let { id, name, image} = tags;
        return `<div id="${id}" class="contact-form__option" data-selectable="" data-value="">
                  <img src="${!!image ? image : '#'}">
                  <span>${name}</span>
                </div>`;
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

  // Создаем selectize
  let $selectState = $selectTag.selectize(options);
  let selectState = $selectState[0].selectize;

  selectState.clear();
  selectState.clearOptions();

  selectState.load((callback) => {
    fetchAutToken({})
      .then( (params) => fetch('/tags/options', params))
      .then( (response) => response.json() )
      .then( (options) => { callback(options); } )
  })
};
