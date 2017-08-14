const { qs } = require('utils');
const fetchCurrentUser            = require('../fetchCurrentUser');

module.exports = (nodes) => {

  nodes.author.addEventListener('click', openRamblerLogin);
  function openRamblerLogin() {
    qs('.rambler-topline__user-signin').click();

    // Колбек срабатывате после входа через рамблер id
    ramblerIdHelper.registerOnPossibleLoginCallback(fetchCurrentUser);
  }
};
