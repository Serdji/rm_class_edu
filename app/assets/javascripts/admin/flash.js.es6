let Flash = (function() {
  function buildElement() {
    let parsed = this.flash.messageTmpl({
      data: { type: this.type, message: this.message }
    });
    let element = $(parsed);

    element.on('click', $.proxy(this.onClose, this));
    this.element = element;
  }

  function FlashMessage(type, message, flash) {
    this.type = type;
    this.message = message;
    this.flash = flash;

    buildElement.call(this);
  }

  FlashMessage.prototype.onClose = function() {
    let index = this.flash.messageQueues.indexOf(this);
    this.flash.messageQueues.splice(index, 1);

    this.element.
      animate({ opacity: 0, left: '25%' }, 150).
      animate({ padding: 0, margin: 0, height: 0 }, 200, function() {
        this.element.remove();
      }.bind(this));
  };

  FlashMessage.prototype.show = function() {
    this.flash.container.append(this.element);
    this.element.animate({ opacity: 1, left: 0 }, 150);

    // TODO: set timeout through parameter
    // setTimeout(function() { this.onClose(); }.bind(this), 2000);
  };

  function Flash() {
    let template = $('#flash-message-template').html();
    if (template !== undefined) {
      this.messageTmpl = _.template($('#flash-message-template').html());
      this.container = $('.flash-messages-container');
      this.messageQueues = [];
    }
  }

  Flash.prototype.add = function(type, message) {
    let flashMessage = new FlashMessage(type, message, this);
    this.messageQueues.push(flashMessage);
    flashMessage.show();
  };

  return new Flash();
})();

$(function() {
  $('.flash-messages .message').each(function() {
    let message = $(this);
    let type = message.data('type');
    let text = message.data('text');

    Flash.add(type, text);
  });
});
