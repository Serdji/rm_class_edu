const { qs }    = require('utils');
const offScroll = require('../menu/offScroll');

if(qs('.js-popular-themes')){
  let nodes = {
    popularThemes: qs('.js-popular-themes'),
    openPopularThemes: qs('.js-open-popular-themes'),
    closePopularThemes: qs('.js-close-popular-themes')
  };

  nodes.openPopularThemes.addEventListener('click', ()=>{
    nodes.popularThemes.classList.remove('_hidden');
    document.body.removeEventListener('touchmove', offScroll); // Снимаем блок скролла на IOS
  });
  nodes.closePopularThemes.addEventListener('click', ()=>{
    nodes.popularThemes.classList.add('_hidden');
    document.body.addEventListener('touchmove', offScroll); // Блок скролла на IOS
  });
}
