const { qs } = require('utils');

qs('.js-send-ga').addEventListener('click', () =>{
  if ( window.ga ) ga('send', 'event', 'подвал_сайта', 'переключение_на_мобильную_версию_сайта', 'нажатие_на_ссылку_мобильная_версия');
})
