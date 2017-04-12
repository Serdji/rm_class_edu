module.exports = {
  each: Function.call.bind([].forEach),
  qs: document.querySelector.bind(document),
  qsa: document.querySelectorAll.bind(document),
  declOfNum: require('declOfNum'),
  fetchAutToken: require('fetchAuthenticityToken'),
  getCoords: require('getCoords')
};
