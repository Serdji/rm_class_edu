function _toggleHeading(cm, direction, level) {
  if (/editor-preview-active/.test(cm.getWrapperElement().lastChild.className)) return;

  let startPoint = cm.getCursor('start');
  let endPoint = cm.getCursor('end');
  for (let i = startPoint.line; i <= endPoint.line; i++) {
    (function(i) {
      let text = cm.getLine(i);
      let currHeadingLevel = text.search(/[^#]/);
      let size = +level;

      if (direction !== undefined) {
        if (currHeadingLevel <= 0) {
          if (direction === 'bigger') {
            text = '###### ' + text;
          } else {
            text = '# ' + text;
          }
        } else if (currHeadingLevel === 6 && direction === 'smaller') {
          text = text.substr(7);
        } else if (currHeadingLevel === 1 && direction === 'bigger') {
          text = text.substr(2);
        } else {
          if (direction === 'bigger') {
            text = text.substr(1);
          } else {
            text = '#' + text;
          }
        }
      } else {
        if (size === 1) {
          if (currHeadingLevel <= 0) {
            text = '# ' + text;
          } else if (currHeadingLevel === size) {
            text = text.substr(currHeadingLevel + 1);
          } else {
            text = '# ' + text.substr(currHeadingLevel + 1);
          }
        } else if (size === 2) {
          if (currHeadingLevel <= 0) {
            text = '## ' + text;
          } else if (currHeadingLevel === size) {
            text = text.substr(currHeadingLevel + 1);
          } else {
            text = '## ' + text.substr(currHeadingLevel + 1);
          }
        } else if (size === 3) {
          if (currHeadingLevel <= 0) {
            text = '### ' + text;
          } else if (currHeadingLevel === size) {
            text = text.substr(currHeadingLevel + 1);
          } else {
            text = '### ' + text.substr(currHeadingLevel + 1);
          }
        } else {
          if (currHeadingLevel <= 0) {
            text = '#### ' + text;
          } else if (currHeadingLevel === size) {
            text = text.substr(currHeadingLevel + 1);
          } else {
            text = '#### ' + text.substr(currHeadingLevel + 1);
          }
        }
      }

      cm.replaceRange(text, {
        line: i,
        ch: 0
      }, {
        line: i,
        ch: 99999999999999
      });
    })(i);
  }
  cm.focus();
}
