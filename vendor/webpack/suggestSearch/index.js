const { qs } = require('utils');

module.exports = class SuggestSearch {
  static get enterButton()   { return 13 }
  static get waitTime()      { return 200 }
  static get endpoint()      { return '/search/suggest' }
  static get templateClass() { return '.js-search-suggest-template' }
  static get novaUrl()       { return 'https://nova.rambler.ru/search?_openstat=Ui1rbGFzczs7Ow' }

  constructor(component) {
    let template = qs(SuggestSearch.templateClass);
    this.template = _.template(template.innerHTML);

    this.component = component;
    this.main = qs('main');

    this.input = component.querySelector('.js-search-input');
    this.clear = component.querySelector('.js-clear-input');
    this.result = component.querySelector('.search-result');

    this._initializeInput();
    this._setupCallbacks();
  }

  run() {
    let debounced = _.debounce(this._onType.bind(this), SuggestSearch.waitTime);
    this.input.addEventListener('keyup', debounced);
    this.input.addEventListener('keyup', () => {
      if (this.input.value.length >= 1) {
        this.clear.classList.remove('clear-input_hidden');
      } else {
        this.clear.classList.add('clear-input_hidden');
      }
    });
  }

  show(compiled) {
    this.main.classList.add('overlap');

    this.result.innerHTML = compiled;
    this.result.classList.remove('search-result_hidden');

    this.mainCallback = this.hide.bind(this);
    this.main.addEventListener('click', this.mainCallback);
  }

  hide() {
    qs('main').classList.remove('overlap');
    this.result.classList.add('search-result_hidden');
    this.main.removeEventListener('click', this.mainCallback);
  }

  _setupCallbacks() {
    let popupQuestion = qs('.js-open-pop-up-ques');
    let questionForm = qs('.js-question-form');

    if (popupQuestion && questionForm) {
      popupQuestion.addEventListener('click', () => {
        this.hide();
        questionForm['question[title]'].value = this.input.value;
      });
    }

    this.clear.addEventListener('click', () => {
      this.hide();
      this.input.value = '';
      this.clear.classList.add('clear-input_hidden');
    });

    this.input.addEventListener('keydown', (event) => {
      if (event.keyCode === SuggestSearch.enterButton) {
        this._onEnterPress();
      }
    });
  }

  _onEnterPress() {
    if (this.input.value.length > 0) {
      let path = `/resultat?_openstat=Ui1rbGFzczs7Ow&query=${encodeURIComponent(this.input.value)}`;
      window.location = path;
    }
  }

  _onType(event) {
    let trimmed = this.input.value.trim();
    if (trimmed.length >= 3) this._search();
  }

  _search() {
    let encodedQuery = encodeURIComponent(this.input.value);
    let url = `${SuggestSearch.endpoint}?query=${encodedQuery}`;

    fetch(url)
      .then((response) => response.json())
      .then((json) => {
        this._render(this._prepareData(json))
      })
  }

  _prepareData(data) {
    let byType = (type) => {
      return (object) => object.type === type;
    };

    let tags = data.matches.filter(byType('tags')).slice(0, 3);
    let questions = data.matches.filter(byType('questions')).slice(0, 3);

    data.tags = tags;
    data.questions = questions;
    data.totalFound = data.total_found;
    data.inputText = this.input.value;

    let encodedQuery = encodeURIComponent(this.input.value);
    data.novaGlobalUrl = `${SuggestSearch.novaUrl}&query=${encodedQuery}`;

    delete data.matches;
    delete data.total_found;

    return data;
  }

  _initializeInput() {
    let params = window.location.search.slice(1).split('&');

    params.forEach((param) => {
      let name = param.split('=')[0];
      let value = param.split('=')[1];
      if (name === 'query') this.input.value = decodeURIComponent(value);
    })
  }

  _render(data) {
    let compiled = this.template(data);
    this.show(compiled);
  }
}
