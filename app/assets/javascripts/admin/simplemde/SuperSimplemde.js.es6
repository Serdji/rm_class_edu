class SuperSimplemde {
  constructor(editor, templateId, text) {
    let template = $(templateId);
    this.editor = editor;
    if (template.length > 0) {
      this.template = _.template($(templateId).html());
    } else {
      throw new Error(text);
    }
  }
}
