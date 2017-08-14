const { qs }         = require('utils');
const stickingButton = require('./stickingButton');

if (qs('.js-sticking-button')){
  let nodes = {
    button: qs('.js-sticking-button'),
    start: qs('.js-sticking-button-start'),
    stop: qs('.js-sticking-button-stop')
  };
  window.addEventListener('scroll', () => {
    stickingButton(nodes);
  });
  window.addEventListener('touchmove', () => {
    stickingButton(nodes);
  });
}
