const { qs, qsa }           = require('utils');
const buttonOpenPopUpAuthor = require('./buttonOpenPopUpAuthor');

let nodes = {
    author: qs('.js-author'),
    user: qsa('.js-user')
};

buttonOpenPopUpAuthor(nodes);
