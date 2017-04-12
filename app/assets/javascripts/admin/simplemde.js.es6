//= require_tree ./simplemde

let toolbar = [
  Toolbar.preview, Toolbar.sideBySide, 'fullscreen',
  '|',
  Toolbar.undo, Toolbar.redo,
  '|',
  'link', Toolbar.image, Toolbar.titlesymbols,
  '|',
  'bold', 'italic', Toolbar.underline,
  '|',
  Toolbar.left, Toolbar.center, Toolbar.right, Toolbar.justify,
  '|',
  'unordered-list', 'ordered-list',
  '|',
  'table',
  '|',
  Toolbar.subscript, Toolbar.superscript,
  '|',
  'guide', Toolbar.greeksymbols
];

$(function() {
  $('.simplemde').each(function() {
    let editor = new SimpleMDE({
      element: this,
      spellChecker: false,
      toolbar: toolbar
    });
  });
});
