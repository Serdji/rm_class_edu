//= require admin/simplemde/envelopeText
//= require admin/simplemde/SuperSimplemde

class GreekSymbolBuilder extends SuperSimplemde {
  constructor(editor, templateId, text) {
    super(editor, templateId, text);

    this.smallGreeks = Array(
      'α', 'β', 'γ', 'δ', 'ε', 'ζ', 'η', 'θ', 'ι', 'κ', 'λ', 'μ',
      'ν', 'ξ', 'ο', 'π', 'ρ', 'σ', 'τ', 'υ', 'φ', 'χ', 'ψ', 'ω'
    );
    this.largeGreeks = Array(
      'Α', 'Β', 'Γ', 'Δ', 'Ε', 'Ζ', 'Η', 'Θ', 'Ι', 'Κ', 'Λ', 'Μ',
      'Ν', 'Ξ', 'Ο', 'Π', 'Ρ', 'Σ', 'Τ', 'Υ', 'Φ', 'Χ', 'Ψ', 'Ω'
    );
  }

  build() {
    let symbols = {
      smallSymbols: this.smallGreeks,
      largeSymbols: this.largeGreeks
    };
    let compiled = $(this.template({ data: symbols }));
    compiled.on('click', 'a.add-symbol', $.proxy(this.insertSymbol, this));
    compiled.on('click', 'a.close-button', function(event) {
      event.preventDefault();
      compiled.addClass('hidden');
    });
    compiled.insertBefore($(this.editor.element));
    compiled.draggable();
    this.editor.greekSymbolSheet = compiled;
    return compiled;
  }
  insertSymbol(e) {
    e.preventDefault();
    envelopeText(this.editor, event.target.innerText, '');
  }
}

