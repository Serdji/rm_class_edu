const { qsa, qs, each } = require('utils');

const body = qs('body');
const fakeSelector = '._fake-link[data-href]';

function openNewWindow(url) {
  let win = window.open(url, '_blank');
  win.focus();
}

let click = function() {
  let href = this.dataset.href;
  let isNewWindow = this.dataset.newWindow;

  if (isNewWindow) {
    openNewWindow(href);
  } else {
    window.location.href = href;
  }
};

each(qsa(fakeSelector), (fakeNode) => {
  fakeNode.addEventListener('click', click);
});
