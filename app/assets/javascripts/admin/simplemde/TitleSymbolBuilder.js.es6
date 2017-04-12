//= require admin/simplemde/toggleHeading
//= require admin/simplemde/SuperSimplemde

class TitleSymbolBuilder extends SuperSimplemde {
  constructor(editor, templateId, text) {
    super(editor, templateId, text);
  }

  build() {
    let symbols = Array(
      'H2', 'H3', 'H4'
    );
    let compiled = $(this.template({ data: symbols }));

    compiled.on('click', 'a.add-symbol', $.proxy(this.insertSymbol, this));
    compiled.on('click', 'a.close-button', function(e) {
      e.preventDefault();
      compiled.addClass('hidden');
    });
    compiled.insertBefore($(this.editor.element));
    compiled.draggable();
    this.editor.titleSymbolSheet = compiled;
    return compiled;
  }

  insertSymbol(e) {
    e.preventDefault();
    let level        = e.target.innerText[1];
    let cm           = this.editor.codemirror;
    _toggleHeading(cm, undefined, level);
  }
}
