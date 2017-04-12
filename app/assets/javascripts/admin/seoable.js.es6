$(function() {
  function Seoable(seoable, templateId) {
    this.seoable = $(seoable);
    this.showBtn = this.seoable.find('.seo-show');
    this.baseUrl = $(templateId).data('url');
    this.modalTmpl = _.template($(templateId).html());
    this.bindEvents();
  }

  Seoable.prototype.url = function() {
    let id = this.seoData().id;
    return this.baseUrl + (id ? '/' + id : '');
  };

  Seoable.prototype.seoData = function() {
    return this.seoable.data('seo');
  };

  Seoable.prototype.bindEvents = function() {
    this.showBtn.on('click', $.proxy(this.show, this));
  };

  Seoable.prototype.show = function() {
    let modal = $(this.modalTmpl({ data: this.seoData() }));

    modal.on('click', '.seo-save', { modal: modal }, $.proxy(this.save, this));
    modal.on('click', '.seo-destroy', { modal: modal }, $.proxy(this.destroy, this));
    modal.on('hidden.bs.modal', function() { $(this).remove(); });

    modal.modal();

    return false;
  };

  Seoable.prototype.hide = function(modal, responseJSON) {
    this.seoable.data('seo', responseJSON || {});
    modal.modal('hide');
  };

  Seoable.prototype.save = function(event) {
    let modal = event.data.modal;
    let self = this;
    let method = this.seoData().id ? 'update' : 'create';
    let formData = modal.find('form').serialize();

    $[method](this.url(), formData)
      .done(this.hide.bind(this, modal))
      .done(function() { self.showBtn.addClass('btn-success'); });
  };

  Seoable.prototype.destroy = function(event) {
    let self = this;
    $.destroy(this.url())
      .done(this.hide.bind(this, event.data.modal))
      .done(function() { self.showBtn.removeClass('btn-success'); });
  };

  $('[data-seo]').each(function() {
    new Seoable($(this), '#seo-modal-template');
  });
});
