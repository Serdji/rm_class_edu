//= require admin/simplemde/envelopeText
//= require admin/simplemde/ImageFormBuilder
//= require admin/simplemde/GreekSymbolBuilder
//= require admin/simplemde/TitleSymbolBuilder

let Actions = {
  drawUnderline(editor) {
    envelopeText(editor, '<u>', '</u>');
  },

  drawSubscript(editor) {
    envelopeText(editor, '<sub>', '</sub>');
  },

  drawSuperscript(editor) {
    envelopeText(editor, '<sup>', '</sup>');
  },

  drawLeft(editor) {
    envelopeText(editor, '<div class="text-left">', '</div>');
  },

  drawCenter(editor) {
    envelopeText(editor, '<div class="text-center">', '</div>');
  },

  drawRight(editor) {
    envelopeText(editor, '<div class="text-right">', '</div>');
  },

  drawJustify(editor) {
    envelopeText(editor, '<div class="text-justify">', '</div>');
  },

  toggleImage(editor) {
    if (!editor.imageFormSheet) {
      let templateId = '#image-form-template';
      new ImageFormBuilder(editor, templateId, 'Image form template not found').build();
    } else {
      editor.imageFormSheet.find('input#image').val('');
      editor.imageFormSheet.find('input#alt').val('');
      editor.imageFormSheet.find('input#title').val('');
      editor.imageFormSheet.find('input#height').val('');
      editor.imageFormSheet.find('input#width').val('');
      editor.imageFormSheet.toggleClass('hidden');
    }
  },

  toggleGreekSymbols(editor) {
    if (!editor.greekSymbolSheet) {
      let templateId = '#greek-symbols-template';
      new GreekSymbolBuilder(editor, templateId, 'Greek symbol template not found').build();
    } else {
      editor.greekSymbolSheet.toggleClass('hidden');
    }
  },

  toggleTitleSymbols(editor) {
    if (!editor.titleSymbolSheet) {
      let templateId = '#title-symbols-template';
      new TitleSymbolBuilder(editor, templateId, 'Image form template not found').build();
    } else {
      editor.titleSymbolSheet.toggleClass('hidden');
    }
  },

  togglePreview(editor) {
    SimpleMDE.togglePreview(editor);
    let cm      = editor.codemirror;
    let wrapper = cm.getWrapperElement();
    let preview = wrapper.lastChild;
    let toolbar = editor.options.toolbar ? editor.toolbarElements.preview : false;
    if (/active/.test(toolbar.className)) {
      MathJax.Hub.Queue(['Typeset', MathJax.Hub, preview]);
    }
  },

  toggleSideBySide(editor) {
    SimpleMDE.toggleSideBySide(editor);
    let cm            = editor.codemirror;
    let wrapper       = cm.getWrapperElement();
    let preview       = wrapper.nextSibling;
    let toolbarButton = editor.toolbarElements['side-by-side'];
    cm.off('update', cm.sideBySideRenderingFunction);
    if (/active/.test(toolbarButton.className)) {
      let buffer = $('<div>');
      MathJax.Hub.Queue(['Typeset', MathJax.Hub, preview]);
      let sideBySideRenderingFunction = _.debounce(function() {
        buffer.html(editor.options.previewRender(editor.value()));
        MathJax.Hub.Queue(
          ['Typeset', MathJax.Hub, buffer[0]],
          function() { preview.innerHTML = buffer.html() }
        );
      }, 300);
      cm.off('update', sideBySideRenderingFunction);
      cm.on('update', sideBySideRenderingFunction);
    }
  }
};
