const filePickerCallback = require('./filePickerCallback');
const sendFormYourAnswer = require('./sendFormYourAnswer');
const sendFormQuestion   = require('./sendFormQuestion');
const closeFormQuestion  = require('./closeFormQuestion');
const editorMaxLength    = require('./editorMaxLength');
const buttonDisabled     = require('./buttonDisabled');

module.exports = (editor, nodes) => {
  let config = {
    selector: editor,
    resize: false,
    statusbar: false,
    paste_as_text: true,
    autoresize_bottom_margin: 0,
    autoresize_max_height: 400,
    // Подключаем нужные нам плагины
    plugins: 'paste placeholder link image autoresize',
    // Выставляем нужные нам элементы и в нужном нам порядке
    toolbar: 'bold italic underline | subscript superscript | image',
    // Отключаем дополнительное меню
    menubar: false,
    // Элементы маленькие
    toolbar_items_size: 'small',
    // Включить поле заголовка в диалоговом окне Image
    image_title: true,
    // Включить автоматическую загрузку изображений, представленных Blob или данных URIs,
    automatic_uploads: true,
    // URL нашего обработчика загрузки (для более подробной информации проверить: https://www.tinymce.com/docs/configure/file-image-upload/#images_upload_url)
    // Images_upload_url: 'postAcceptor.php',
    // Здесь мы добавляем пользовательские filepicker только диалог изображения
    relative_urls: false,
    remove_script_host: false,
    convert_urls: true,
    file_picker_types: 'image',
    // И вот наш подборщика пользовательских изображений
    file_picker_callback(cb, value, meta) {
      filePickerCallback(cb, value, meta);
    },
    // Колбек, действие после инициилизации редактора
    setup(ed) {
      setTimeout(()=>{
        // Снимаем фокус с инпута в пункте добавить картинку
        $('.mce-widget').on('click', ()=>{
          setTimeout(()=>{
            $('.mce-in input').blur();
          }, 100);
        })
      }, 1000);
      // при клики на кнопку вызываем функцию отправки сообщения
      if ( nodes.EDITOR_TYPE_ANSWER ) {
        nodes.formButton.addEventListener('click', () => sendFormYourAnswer(nodes));
        ed.on('keyup', () => buttonDisabled(nodes, ed));
      }

      if ( nodes.EDITOR_TYPE_QUANTITY ) {
        nodes.sendQuestion.addEventListener('click', () => sendFormQuestion(nodes, ed));
        nodes.closeQuestion.addEventListener('click', () => closeFormQuestion(nodes, ed));
      }

      ed.on('keypress', () => editorMaxLength(nodes, ed));
      ed.on('keydown', e => {if (e.keyCode === 8) editorMaxLength(nodes, ed);});
      ed.on('focus', () => ed.editorContainer.classList.add('_editor-focus'));
      ed.on('blur', () => ed.editorContainer.classList.remove('_editor-focus'));
    },
    // После того как текст вставят, запускаем пересчет
    paste_postprocess(plugin, args) {
      editorMaxLength(nodes, args.target);
    },
    // Перед вставкой текста, обрезаем его и пересчитываем
    paste_preprocess(plugin, args) {
      let remainderLength = editorMaxLength(nodes, args.target);
      if (remainderLength) args.content = args.content.slice(0, remainderLength);
      else args.content = '';
    }
  };

  // В зависимости от класса конфигурируются разные конфиги
  if ( nodes.EDITOR_TYPE_ANSWER ) {
    config.min_height = 45;
  }

  if ( nodes.EDITOR_TYPE_QUANTITY ) {
    config.min_height = 87;
  }

  return config;
};
