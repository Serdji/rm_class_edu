const fetchCurrentUser = require('./fetchCurrentUser');

module.exports = () => {
  // Колбек срабатывате после входа через рамблер id
  ramblerIdHelper.registerOnPossibleLoginCallback(fetchCurrentUser);
};
