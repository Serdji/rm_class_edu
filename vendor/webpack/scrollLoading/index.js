let qsa = document.querySelectorAll.bind(document);
let qs  = document.querySelector.bind(document);

function throttle(func, time, context) {
  let running = false;

  return function() {
    if (!running) {
      running = true;
      setTimeout(function() { running = false; }, time);
      func.apply(context, arguments);
    }
  };
}

class Scrolling {
  static get loadMoreDataName() { return 'loadmoreLink'; }
  static get scrollableClass() { return '.js-scroll-load'; }
  static get waitTime() { return 50; }

  constructor() {
    this.running = true;
    this.loading = false;

    this.scrolling    = qs(Scrolling.scrollableClass);
    this.elementClass = this.scrolling.dataset.scrollable;
    this.listener     = throttle(this.onScroll, Scrolling.waitTime, this);

    this.updateElements();
  }

  run() {
    window.addEventListener('scroll', this.listener);
  }

  stop() {
    window.removeEventListener('scroll', this.listener);
  }

  loadMoreLink() {
    let link = this.scrolling.dataset[Scrolling.loadMoreDataName];
    let url  = new URL(link);

    let path   = url.pathname;
    let search = url.search;

    let param = `offset=${this.scrollables.length}`;
    search    = search ? `${search}&${param}` : param;

    return path + search;
  }

  updateElements() {
    this.scrollables = qsa(this.elementClass);
    this.lastElement = this.scrollables[this.scrollables.length - 1];
  }

  onScroll() {
    let relativeTop         = this.lastElement.getBoundingClientRect().top;
    let currentScreenHeight = window.innerHeight;

    if (relativeTop <= currentScreenHeight && !this.loading) {
      this.loading = true;
      this.loadMore();
    }
  }

  loadMore() {
    fetch(this.loadMoreLink()).then(function(response) {
      return response.text();
    }).then(this.updateData.bind(this));
  }

  updateData(data) {
    if (!data.trim()) this.stop();

    this.scrolling.innerHTML += data;

    let scripts = this.scrolling.querySelectorAll('.need-eval');
    [].forEach.call(scripts, el => {
      eval(el.innerText);
      el.classList.remove('need-eval');
    });

    this.updateElements();
    this.loading = false;
  }
}


if (qs(Scrolling.scrollableClass)) {
  let scrolling = new Scrolling();
  scrolling.run();
}
