//= require admin/simplemde/envelopeText
//= require admin/simplemde/SuperSimplemde

class ImageFormBuilder extends SuperSimplemde {
  constructor(editor, templateId, text) {
    super(editor, templateId, text);

    $('body').on('change keyup input click', '.js-img-sizes', function() {
      if (this.value.match(/[^0-9]/g)) {
        this.value = this.value.replace(/[^0-9]/g, '');
      }
    });
  }

  build() {
    let compiled = $(this.template());
    let editor   = this.editor;

    compiled.on('click', 'input#uploaded_file_insert', function(e) {
      e.preventDefault();
      let url = $(this).closest('form').find('#temp_image_url').val();

      if (url.length > 0) {
        $('#uploaded_file_insert').css('disabled', false);

        let form       = $(this).closest('form');
        let attributes = ['data-id="0"'];
        let alt        = form.find('input#alt').val();
        let title      = form.find('input#title').val();
        let width      = form.find('input#width').val();
        let height     = form.find('input#height').val();

        if (width) attributes.push(`width="${width}"`);
        if (height) attributes.push(`height="${height}"`);
        if (attributes.length) {
          attributes = `{:${attributes.join(' ')}}`;
        } else {
          attributes = '';
        }
        if (title) url = `${url} "${title}"`;
        envelopeText(editor, `![${alt}](${url})${attributes}`, '');
      }
      compiled.addClass('hidden');
    });
    compiled.on('click', 'a.close-button', function(e) {
      e.preventDefault();
      compiled.addClass('hidden');
    });
    compiled.find('.webdav-file').each(function() {
      new FileUpload(this);
    });
    compiled.insertBefore($(this.editor.element));
    compiled.draggable();
    this.editor.imageFormSheet = compiled;
    return compiled;
  }
}

