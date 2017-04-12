$(function() {
	 // Максимальное колличество тегов
  let $selectTag = $('.js-select-ize');
  let url = $selectTag.data('url');
	let options = {
    plugins: ['remove_button', 'drag_drop'],
    valueField: 'id',
    labelField: 'name',
    searchField: 'name',
    create: false,
    render: {
      option(tags) {
        let { id, name } = tags;
        return `<div id="${id}" class="option" data-selectable="" data-value="">${name}</div>`;
      }
    },
    onChange(arrVal) {
      $selectTag.attr('value', arrVal);
    },
    load(query, callback) {
      if (!query.length) return callback();
      $.ajax({
        url: url + encodeURIComponent(query),
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
	$selectTag.selectize(options);
  $('.unvisible').removeClass('unvisible');
});
