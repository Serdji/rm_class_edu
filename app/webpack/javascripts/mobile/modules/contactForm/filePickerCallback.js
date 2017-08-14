const { qsa, each, fetchAutToken } = require('utils');

module.exports = (nodes) => {

  nodes.inputPicture.addEventListener('change', sendFile);

   function sendFile() {
    // Записываем имя файла
    let file = this.files[0];

    let formData = new FormData();
    formData.append('image', file);

    // Передаем картинку на сервер
    let params = {
      method: 'POST',
      body: formData
    };

    fetchAutToken(params)
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
        let { id, url } = json;
        let html =`<img id="${id}" src="${url}" ><br><br>`;
        // Добавляем картинку в поле с текстом
        nodes.textDescription.insertAdjacentHTML('beforeEnd', html);
        // Что бы можно было отправить картинку с таким же названием
        this.value = null;

      })
      .catch(error => {
        console.error(error)
      });
  };

};
