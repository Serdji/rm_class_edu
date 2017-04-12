let FileUpload = (function() {
  function addErrorMessage(element, extensions) {
    // TODO: we shouldn't hardcode messages in code
    let message = 'можно загружать изображения в формате ' + extensions.join(', ');
    let div     = $('<div>').addClass('field_error');
    let error   = $('<span>').wrap(div).html(message);
    element.after(error.parent());
  }

  function FileUpload(element) {
    this.fileInput    = $(element);
    this.wdBackend    = wd;
    this.extensions   = this.fileInput.data('extensions');
    this.submitButton = this.fileInput.parents('form').find('button');
    this.fileInput.on('change', $.proxy(this.onChange, this));
  }

  FileUpload.prototype.upload = function(file) {
    let fileInput = this.fileInput;
    this.wdBackend.put('tmp/', file, function(fullPath) {
      let tempUrlField = fileInput.parent().find('.webdav-temp');
      tempUrlField.val(fullPath);
    });
  };

  FileUpload.prototype.onChange = function(event) {
    let file = event.target.files[0];
    if (this.validateExtension(file)) {
      this.upload(file);
    } else {
      this.fileInput.val(null);
    }
  };

  FileUpload.prototype.validateExtension = function(file) {
    if (!this.extensions) return;
    let extension = file.type.replace(/image\/*/, '');
    if (!extension || this.extensions.indexOf(extension) === -1) {
      addErrorMessage(this.fileInput, this.extensions);
    } else {
      this.fileInput.next('div').remove();
      return true;
    }
  };
  return FileUpload;
})();

$(function() {
  $('.webdav-file').each(function() {
    new FileUpload(this);
  });
});
