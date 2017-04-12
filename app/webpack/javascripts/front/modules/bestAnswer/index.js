const { qs, qsa, fetchAutToken } = require('utils');

let allAnswers = qs('.all-answers');

if (allAnswers) {
  allAnswers.addEventListener('click', (event) => {
    let target = event.target;

    if (target.classList.contains('js-make-best-answer')) {
      let url = target.dataset.url;

      let params = { method: 'POST'};

      fetchAutToken(params)
        .then( params => fetch(url, params))
        .then( response => {
          let { status, statusText } = response;
          if (status >= 200 && status < 300) {
            return response.json();
          } else {
            throw new Error(statusText);
          }
        })
        .then(json => {
          if (json.success) {
            document.location.href = json.url;
          } else {
            console.error('Make best answer for url: %s with error', json.url);
          }
        })
    }
  });
}
