const { fetchAutToken, each } = require('utils');

module.exports = nodes => {
  nodes.buttonSend.addEventListener('click', send);
  function send() {
    const url = nodes.complaintForm.action;

    let causeIds = [];
    each(nodes.complaintForm['complaint[cause_ids][]'], checkbox => {
      if (checkbox.checked) causeIds.push(checkbox.value);
    });

    let body = nodes.complaintForm['complaint[body]'].value;
    let email = nodes.complaintForm['complaint[email]'].value;
    let complainableId = nodes.complaintForm['complaint[complainable_id]'].value;
    let complainableType = nodes.complaintForm['complaint[complainable_type]'].value;

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
        }
      })
    };

    fetchAutToken(params)
      .then(params => fetch(url, params))
      .then(response => {
        let { status, statusText } = response;
        let json = response.json();

        if (status >= 200 && status < 300) {
          return json;
        } else {
          return json.then(responseError => {
            let error = Error(statusText);
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
      .catch(response => {
        if (response.message === 'Unprocessable Entity') {
          response.errors.forEach((error) => {
            let attribute = error.source.replace(/\/data\/attributes\//, '');
            nodes.complaintForm[`complaint[${attribute}]`].classList.add('_editor-error');
          });
        }

        if (response.message === 'Unauthorized') {
          qs('.rambler-topline__user-signin').click();
        }
      });
  }
};
