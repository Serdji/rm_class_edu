const { qs }    = require('utils');
const openClose = require('./openClose');

if (qs('.js-themes-drop-down')){
  let nodes = {
    themesDropDown: qs('.js-themes-drop-down'),
    openThemesDropDown: qs('.js-open-themes-drop-down'),
    menuThemesDropDown: qs('.js-menu-themes-drop-down'),
    menuQuesThemesDropDown: qs('.js-menu-ques-themes-drop-down'),
  };
  openClose(nodes);
}

