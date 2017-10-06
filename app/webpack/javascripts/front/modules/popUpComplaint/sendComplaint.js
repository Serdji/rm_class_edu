const { fetchAutToken, each, qs } = require('utils');
const Captcha = require('captcha');

module.exports = nodes => {
  nodes.buttonSend.addEventListener('click', send);
  function send() {
    const url = nodes.complaintForm.action;

    let causeIds = [];
    each(nodes.complaintForm['complaint[cause_ids][]'], checkbox => {
      if (checkbox.checked) causeIds.push(checkbox.value);
    });

    let body             = nodes.complaintForm['complaint[body]'].value;
    let email            = nodes.complaintForm['complaint[email]'].value;
    let complainableId   = nodes.complaintForm['complaint[complainable_id]'].value;
    let complainableType = nodes.complaintForm['complaint[complainable_type]'].value;
    let captcha          = new Captcha('.js-captcha-complaint');

    let params = {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        complaint: {
          complainable_id: complainableId,
          complainable_type: complainableType,
          cause_ids: causeIds,
          body: body,
          email: email
        },
        captcha: {
          id: captcha.getId(),
          input: captcha.getInput()
        }
      })
    };

    this.setAttribute('disabled', 'disabled');

    fetchAutToken(params)
      .then(params => fetch(url, params))
      .then(response => {
        let { status } = response;
        let json = response.json();
        if (status >= 200 && status < 300) {
          this.removeAttribute('disabled');
          captcha.remove();
          return json;
        } else {
          this.removeAttribute('disabled');
          return json.then(responseError => {
            let error = Error(status);
            error.errors = responseError.errors;
            throw error;
          });
        }
      })
      .then(json => {
        nodes.complaintForm.style.display = 'none';
        nodes.complaintForm.reset();
        nodes.complaintSuccess.style.display = 'table-cell';
      })
      .catch(({message, errors}) => {
        switch (message){
          case '422':
            Object.keys(errors).forEach((error) => {
              nodes.complaintForm[`complaint[${error}]`].classList.add('_editor-error');
            });
            break;
          case '429':
            this.removeAttribute('disabled');
            captcha.run();
            break;
          case '401': qs('.rambler-topline__user-signin').click(); break;
        }
      });
  }
};
