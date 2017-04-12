const url = '/authenticity_token';
const header = 'X-CSRF-Token';

module.exports = (params) => {
  if (!params.headers) params.headers = {};

  return fetch(url, { credentials: 'same-origin' }).
    then(response => response.json()).
    then(json => {
      params.headers[header] = json.token;
      params.credentials = 'same-origin';
      return params;
    });
};
