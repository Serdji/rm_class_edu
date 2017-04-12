const { qs } = require('utils');
const SuggestSearch = require('suggestSearch');

let suggestComponent = qs('.search .search__select');

if (suggestComponent) {
  let suggestSearch = new SuggestSearch(suggestComponent);
  suggestSearch.run();
  require('./redirectLink')();
}
