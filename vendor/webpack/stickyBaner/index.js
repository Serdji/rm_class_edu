'use strict';

class StickyBaner {
  constructor(options) {
    this.floatStartStop = options.floatStartStop;
    this.floatAds       = options.floatAds;
    this.floatSidebar   = options.floatSidebar;
    this.floatWrapper   = options.floatWrapper;
    this.floatContent   = options.floatContent;
    this.footer         = options.footer;
    this.floatBlockCoor = this.getCoords(this.floatStartStop).top;
    this.setEvents();
  }

  setEvents() {
    window.addEventListener('scroll', this.run.bind(this), false);
    window.addEventListener('resize', this.run.bind(this), false);
  }

  run() {
    let boundContRect    = this.getCoords(this.floatSidebar);
    let boundBlockH      = this.floatAds.offsetHeight;
    let floatSidebarMB   = parseInt(getComputedStyle(this.floatSidebar).marginBottom, 10);
    let contentPadBot    = parseInt(getComputedStyle(this.floatWrapper).paddingBottom, 10);
    let footerCoor       = this.footer.getBoundingClientRect().top - floatSidebarMB - contentPadBot - boundBlockH;
    let warmingUpReading = (window.pageYOffset || document.documentElement.scrollTop);
    if (this.floatSidebar.offsetHeight > this.floatContent.offsetHeight) return;
    if (this.floatBlockCoor > warmingUpReading) {
      this.floatAds.classList.remove('_sticky');
      this.floatAds.style.cssText = '';
    } else {
      this.floatAds.style.cssText = footerCoor < 0 ? `bottom: ${contentPadBot}px` : `left: ${boundContRect.left}px;`;
      this.floatAds.classList[footerCoor < 0 ? 'remove' : 'add']('_sticky');
      this.floatAds.classList[footerCoor < 0 ? 'add' : 'remove']('_sticky-footer');
    }
  }

  getCoords(elem) {
    let box        = elem.getBoundingClientRect();
    let body       = document.body;
    let docEl      = document.documentElement;
    let scrollTop  = window.pageYOffset || docEl.scrollTop || body.scrollTop;
    let scrollLeft = window.pageXOffset || docEl.scrollLeft || body.scrollLeft;
    let clientTop  = docEl.clientTop || body.clientTop || 0;
    let clientLeft = docEl.clientLeft || body.clientLeft || 0;
    let top        = box.top + scrollTop - clientTop;
    let left       = box.left + scrollLeft - clientLeft;
    return {
      top: top,
      left: left
    };
  }
}

module.exports = StickyBaner;

