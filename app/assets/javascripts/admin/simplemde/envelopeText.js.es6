function envelopeText(editor, begin, end) {
  let cm = editor.codemirror;
  let output = '';
  let cursor = cm.getCursor();
  let selectedText = cm.getSelection();
  output = begin + selectedText + end;
  cm.replaceSelection(output);
  cm.focus();
  cursor.ch += (begin + selectedText).length;
  cm.setCursor(cursor);
}
