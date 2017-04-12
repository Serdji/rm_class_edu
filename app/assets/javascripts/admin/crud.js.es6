$(function() {
  function request(method, url, data) {
    let options = { method: method, dataType: 'json' };
    if (data) options.data = data;

    return $.ajax(url, options);
  }

  $.create = function(url, data) {
    return request('POST', url, data);
  };

  $.update = function(url, data) {
    return request('PUT', url, data);
  };

  $.destroy = function(url) {
    return request('DELETE', url);
  };
});
