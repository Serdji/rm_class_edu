module.exports = elem => {
  let box = elem.getBoundingClientRect();

  let body = document.body;
  let docEl = document.documentElement;

  let scrollTop = window.pageYOffset || docEl.scrollTop || body.scrollTop;
  let scrollLeft = window.pageXOffset || docEl.scrollLeft || body.scrollLeft;

  let clientTop = docEl.clientTop || body.clientTop || 0;
  let clientLeft = docEl.clientLeft || body.clientLeft || 0;

  let top = box.top + scrollTop - clientTop;
  let left = box.left + scrollLeft - clientLeft;
  let bottom = box.bottom - scrollTop + clientTop;
  let right = box.right - scrollLeft + clientLeft;

  return {
    top: top,
    left: left,
    bottom: bottom,
    right: right
  };
};
