(() => {
  let copyDate = document.querySelector('.js-date');
  if (copyDate) {
    let date = new Date();
    copyDate.innerText = date.getFullYear();
  }
})();
