const { qs } = require('utils');
const SuggestSearch = require('suggestSearch');

if (qs('.js-search-button') && qs('.search')) {
  let nodes = {
    openSearch: qs('.js-search-button'),
    searchInput: qs('.js-search-input'),
    clearSearch: qs('.js-clear-input'),
    closeSearch: qs('.js-search-close'),
    searchBlock: qs('.search')
  };

  require('./activeSearch')(nodes);
  require('./redirectLink')(nodes);
}

let suggestComponent = qs('.search');

if (suggestComponent) {
  let suggestSearch = new SuggestSearch(suggestComponent);
  suggestSearch.run();
}
