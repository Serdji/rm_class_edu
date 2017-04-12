//= require admin/simplemde/Actions

let Toolbar = {
  preview: {
    name: 'preview',
    action: Actions.togglePreview,
    className: 'fa fa-eye no-disable',
    title: 'Preview',
  },

  sideBySide: {
    name: 'side-by-side',
    action: Actions.toggleSideBySide,
    className: 'fa fa-columns no-disable no-mobile',
    title: 'Toggle Side by Side'
  },

  undo: {
    name: 'undo',
    action: SimpleMDE.undo,
    className: 'fa fa-undo',
    title: 'Undo Button',
  },

  redo: {
    name: 'redo',
    action: SimpleMDE.redo,
    className: 'fa fa-rotate-right',
    title: 'Redo Button',
  },

  underline: {
    name: 'underline',
    action: Actions.drawUnderline,
    className: 'fa fa-underline',
    title: 'Underline Button'
  },

  left: {
    name: 'left',
    action: Actions.drawLeft,
    className: 'fa fa-align-left',
    title: 'Left Button'
  },

  center: {
    name: 'center',
    action: Actions.drawCenter,
    className: 'fa fa-align-center',
    title: 'Center Button'
  },

  right: {
    name: 'right',
    action: Actions.drawRight,
    className: 'fa fa-align-right',
    title: 'Left Button'
  },

  justify: {
    name: 'justify',
    action: Actions.drawJustify,
    className: 'fa fa-align-justify',
    title: 'Justify Button'
  },

  image: {
    name: 'image',
    action: Actions.toggleImage,
    className: 'fa fa-image',
    title: 'Image Button'
  },

  subscript: {
    name: 'subscript',
    action: Actions.drawSubscript,
    className: 'fa fa-subscript',
    title: 'Subscript Button'
  },

  superscript: {
    name: 'superscript',
    action: Actions.drawSuperscript,
    className: 'fa fa-superscript',
    title: 'Superscript Button'
  },

  greeksymbols: {
    name: 'greeksymbols',
    action: Actions.toggleGreekSymbols,
    className: 'fa fa-gr js-greek-symbols',
    title: 'Greek Symbols Button'
  },

  titlesymbols: {
    name: 'titlesymbols',
    action: Actions.toggleTitleSymbols,
    className: 'fa fa-header',
    title: 'Header Symbols Button'
  }
};
