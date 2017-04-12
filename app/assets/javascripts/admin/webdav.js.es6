let WebDav = (function() {
  function uuid() {
    let timestamp = new Date();
    return Math.floor((1 + Math.random()) * 0x10000000).toString(16);
  }

  let WebDav = function WebDav(options) {
    options = options || {};

    if (options.webdav) {
      this.environment = options.environment;
      this.host = options.webdav_host;
    } else {
      this.host = options.webdav_mock;
    }

    this.backend = fetchBackend();

    function fetchBackend() {
      if (typeof $ !== 'undefined' && typeof(jQuery !== 'undefined')) {
        return $;
      } else {
        throw new Error('jQuery is not found');
      }
    }
  };

  WebDav.prototype = {
    fullPath: function(path) {
      if (path.slice(-1) === '/') {
        path = [path + uuid(), 'jpg'].join('.');
      }

      if (!Education.config.webdav) path = null;

      return [this.host, this.environment, path].filter(function(e) { return !!e; }).join('/');
    },

    propfind: function(path, callback) {
      this.backend.ajax(this.fullPath(path), {
        method: 'PROPFIND',
        headers: {
          'Depth': 1
        },
        complete: callback
      });
    },

    // TODO: refactor and simplify
    put: function(path, file, callback) {
      let blob = new Blob([file]);
      let fullPath = this.fullPath(path);
      let data = null;
      let pathToReturn = null;

      if (Education.config.webdav) {
        data = blob;
        pathToReturn = fullPath;
      } else {
        data = new FormData();

        let fileName = file.name.replace(/(.*\.)(\w+)$/i, function(match, p1, p2) {
          return p1 + p2.toLowerCase();
        });

        data.append('file', blob, fileName);
        pathToReturn = [document.location.origin, 'tmp', fileName].join('/');
      }

      this.backend.ajax(fullPath, {
        method: 'PUT',
        data: data,
        complete: callback.bind(null, pathToReturn),
        contentType: false,
        processData: false
      });
    },

    delete: function(path, callback) {
      this.backend.ajax(this.fullPath(path), {
        method: 'DELETE',
        complete: callback
      });
    }
  };

  return WebDav;
})();

let wd = new WebDav(Education.config);
