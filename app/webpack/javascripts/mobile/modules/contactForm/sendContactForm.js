const { CONTACT_FORM_QUES,
        CONTACT_FORM_ANSWER
      }            = require('./constants');
const formQuestion = require('./formQuestion');
const formAnswers  = require('./formAnswers');

module.exports = (nodes) => {

  nodes.sendButton.addEventListener('click', sendContactForm);

  function sendContactForm() {
    switch (nodes.type) {
      case CONTACT_FORM_QUES:
        formQuestion(nodes);
        break;
      case CONTACT_FORM_ANSWER:
        formAnswers(nodes);
        break;
    }
  }

};
