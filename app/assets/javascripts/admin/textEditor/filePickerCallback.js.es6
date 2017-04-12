function filePickerCallback(cb, value, meta) {
  let input = document.createElement('input');

  input.setAttribute('type', 'file');
  input.setAttribute('accept', 'image/*');

  input.onchange = function() {
    let file = this.files[0];

    let formData = new FormData();
    formData.append('image', file);

    let url = '/authenticity_token';
    let header = 'X-CSRF-Token';

    // Передаем параметры
    let params = {
      method: 'POST',
      body: formData,
      headers: {}
    };

    fetch(url, { credentials: 'same-origin' })
      .then(response => response.json())
      .then(json => {
        params.headers[header] = json.token;
        params.credentials = 'same-origin';
        return params;
      })
      .then( params => fetch('/upload_image', params))
      .then( response => {
        let { status, statusText } = response;
        if (status >= 200 && status < 300) {
          return response.json();
        } else {
          throw new Error(statusText);
        }
      })
      .then(json => {
        let editor = tinymce.activeEditor;

        editor.uploadedImageIds || (editor.uploadedImageIds = []);
        editor.uploadedImageIds.push(json.id);

        cb(json.url, { title: file.name });
      })
      .catch(error => {
        console.error(error);
      });
  };

  input.click();
}
